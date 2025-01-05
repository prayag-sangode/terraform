# Output for VPC Network CIDR (manual input of CIDR)
output "vpc_network_cidr" {
  value = "10.0.0.0/16"  # Specify the VPC CIDR manually
  description = "The CIDR range of the VPC network"
}

# Output for Public Subnet 1 CIDR
output "public_subnet_1_cidr" {
  value = google_compute_subnetwork.public_subnet_1.ip_cidr_range
  description = "The CIDR range for Public Subnet 1"
}

# Output for Public Subnet 2 CIDR
output "public_subnet_2_cidr" {
  value = google_compute_subnetwork.public_subnet_2.ip_cidr_range
  description = "The CIDR range for Public Subnet 2"
}

# Output for Private Subnet 1 CIDR
output "private_subnet_1_cidr" {
  value = google_compute_subnetwork.private_subnet_1.ip_cidr_range
  description = "The CIDR range for Private Subnet 1"
}

# Output for Private Subnet 2 CIDR
output "private_subnet_2_cidr" {
  value = google_compute_subnetwork.private_subnet_2.ip_cidr_range
  description = "The CIDR range for Private Subnet 2"
}

# Output for Bastion Instance Public IP
output "bastion_public_ip" {
  value = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
  description = "The public IP of the Bastion host"
}

# Output for Bastion Instance Private IP
output "bastion_private_ip" {
  value = google_compute_instance.bastion.network_interface[0].network_ip
  description = "The private IP of the Bastion host"
}
