# Create Database VM in Private Subnet
resource "google_compute_instance" "db_vm" {
  name         = "db-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  network_interface {
    network       = google_compute_network.vpc_network.id
    subnetwork    = google_compute_subnetwork.private_subnet_1.id

    # No public IP assigned, so do not include an access_config block
    access_config {}
  }

  # Set the image for the database VM (e.g., Ubuntu)
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-noble-amd64-v20241219"  # Update as necessary
    }
  }

  tags = ["db-vm"]

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"  # Dynamically load the public SSH key
  }
}

# Allow access from Bastion host to DB VM (SSH or DB port)
resource "google_compute_firewall" "allow_db_access" {
  name    = "allow-db-access"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["22", "3306"]  # Modify ports if needed
  }
  source_ranges = ["10.0.0.2/32"]  # Only allow access from Bastion host IP
  target_tags   = ["db-vm"]
}


# Output the private IP of the DB VM
output "db_vm_private_ip" {
  value = google_compute_instance.db_vm.network_interface[0].network_ip
  description = "The private IP address of the database VM"
}

