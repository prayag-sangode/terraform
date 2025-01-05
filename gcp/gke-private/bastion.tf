# Create Bastion Host in Public Subnet
resource "google_compute_instance" "bastion" {
  name         = "bastion-host"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  network_interface {
    network       = google_compute_network.vpc_network.id
    subnetwork    = google_compute_subnetwork.public_subnet_1.id
    access_config {
      # The access_config block is required to assign a public IP
      nat_ip = google_compute_address.bastion_public_ip.address # Assign a static public IP
    }
  }

  # Set the image for the bastion host to Ubuntu 24
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-noble-amd64-v20241219"  # Updated image name
    }
  }

  tags           = ["bastion"]

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"  # Dynamically load the public SSH key
  }

  # No service account block; the default service account will be used.
}

# Create a static public IP for the bastion host
resource "google_compute_address" "bastion_public_ip" {
  name   = "bastion-public-ip"
  region = "us-central1"
}

# Firewall Rule for Bastion Host Access (Allow SSH)
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-bastion"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}
