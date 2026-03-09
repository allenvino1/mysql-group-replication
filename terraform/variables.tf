variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-southeast1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "asia-southeast1-b"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "mysql-gr-vpc"
}

variable "subnet_cidr" {
  description = "CIDR for the MySQL subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "machine_type" {
  description = "GCE machine type for MySQL nodes"
  type        = string
  default     = "n2-standard-2"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 50
}

variable "node_count" {
  description = "Number of MySQL nodes (minimum 3 for fault tolerance)"
  type        = number
  default     = 3

  validation {
    condition     = var.node_count >= 3
    error_message = "Group Replication requires at least 3 nodes for fault tolerance."
  }
}

variable "os_image" {
  description = "Boot disk image (Rocky Linux 8 on GCP)"
  type        = string
  default     = "rocky-linux-cloud/rocky-linux-8"
}

variable "ansible_user" {
  description = "OS user that Ansible will SSH in as"
  type        = string
  default     = "ansible"
}

variable "ssh_public_key_path" {
  description = "Path to the public SSH key to inject into instances"
  type        = string
  default     = "~/.ssh/gcp_mysql_key.pub"
}

variable "admin_cidr_ranges" {
  description = "CIDR ranges allowed to SSH into the MySQL nodes"
  type        = list(string)
  default     = ["0.0.0.0/0"] # restrict this in production
}

variable "mysql_client_cidr_ranges" {
  description = "CIDR ranges allowed to connect to MySQL port 3306"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
