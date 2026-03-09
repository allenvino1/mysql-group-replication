# --------------------------------------------------------------------------- #
# VPC + Subnet
# --------------------------------------------------------------------------- #
resource "google_compute_network" "mysql_gr" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mysql_gr" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.mysql_gr.id
}

# --------------------------------------------------------------------------- #
# Firewall rules
# --------------------------------------------------------------------------- #
# SSH access from admin CIDRs
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh"
  network = google_compute_network.mysql_gr.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.admin_cidr_ranges
  target_tags   = ["mysql-gr"]
}

# MySQL client access (3306) from allowed CIDRs
resource "google_compute_firewall" "allow_mysql" {
  name    = "${var.network_name}-allow-mysql"
  network = google_compute_network.mysql_gr.name

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = var.mysql_client_cidr_ranges
  target_tags   = ["mysql-gr"]
}

# Group Replication inter-node communication (33061) — internal only
resource "google_compute_firewall" "allow_gr" {
  name    = "${var.network_name}-allow-gr"
  network = google_compute_network.mysql_gr.name

  allow {
    protocol = "tcp"
    ports    = ["33061"]
  }

  # Only nodes within the subnet talk to each other on this port
  source_ranges = [var.subnet_cidr]
  target_tags   = ["mysql-gr"]
}

# --------------------------------------------------------------------------- #
# Compute instances
# --------------------------------------------------------------------------- #
resource "google_compute_instance" "mysql_node" {
  count        = var.node_count
  name         = "mysql-node-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["mysql-gr"]

  boot_disk {
    initialize_params {
      image = var.os_image
      size  = var.disk_size_gb
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.mysql_gr.id

    # Remove this block if you don't need a public IP (use Cloud NAT instead)
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_public_key_path)}"
  }

  # Prevent accidental deletion of database nodes
  lifecycle {
    prevent_destroy = false # set to true after initial provisioning
  }
}
