output "instance_names" {
  description = "Names of the MySQL GR instances"
  value       = google_compute_instance.mysql_node[*].name
}

output "internal_ips" {
  description = "Internal IP addresses of the MySQL GR instances"
  value       = google_compute_instance.mysql_node[*].network_interface[0].network_ip
}

output "external_ips" {
  description = "External IP addresses (if access_config is present)"
  value       = [for inst in google_compute_instance.mysql_node : try(inst.network_interface[0].access_config[0].nat_ip, "no-public-ip")]
}

# Renders a ready-to-use Ansible inventory file.
# After `terraform apply`, run:
#   terraform output -raw ansible_inventory > ../ansible-setup/inventory
output "ansible_inventory" {
  description = "Generated Ansible inventory — paste into ansible-setup/inventory"
  value = <<-EOT
[mysql_primary]
${google_compute_instance.mysql_node[0].name}  node_id=1  ansible_host=${google_compute_instance.mysql_node[0].network_interface[0].network_ip}  ansible_user=${var.ansible_user}  ansible_ssh_private_key_file=~/.ssh/gcp_mysql_key

[mysql_secondary]
%{for i in range(1, var.node_count)~}
${google_compute_instance.mysql_node[i].name}  node_id=${i + 1}  ansible_host=${google_compute_instance.mysql_node[i].network_interface[0].network_ip}  ansible_user=${var.ansible_user}  ansible_ssh_private_key_file=~/.ssh/gcp_mysql_key
%{endfor~}

[databases:children]
mysql_primary
mysql_secondary
EOT
}
