data "google_container_engine_versions" "available_versions" {
  location = "us-central1"
}

# Reference to get Bastion host internal IP dynamically
data "google_compute_instance" "bastion_instance" {
  name   = google_compute_instance.bastion.name
  zone   = google_compute_instance.bastion.zone
}

resource "google_container_cluster" "gke_cluster" {
  name               = "my-gke-cluster"
  location           = "us-central1-a"
  initial_node_count = 1
  node_version       = data.google_container_engine_versions.available_versions.latest_master_version
  min_master_version = data.google_container_engine_versions.available_versions.latest_master_version

  deletion_protection = false

  # Networking
  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.private_subnet_1.id

  # Enable private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true  # Set to true for private endpoint access
  }

  # Allow access from Bastion host's private subnet or dynamically retrieved IP
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = format("%s/32", data.google_compute_instance.bastion_instance.network_interface[0].network_ip)
      display_name = "Bastion Host Access"
    }
  }
}

resource "google_compute_firewall" "allow_bastion_to_gke" {
  name    = "allow-bastion-to-gke"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = [format("%s/32", data.google_compute_instance.bastion_instance.network_interface[0].network_ip)]  # Correct string concatenation
  target_tags   = ["gke-api"]
}

# Define a custom node pool
resource "google_container_node_pool" "my_nodegroup1" {
  name       = "my-nodegroup1"
  cluster    = google_container_cluster.gke_cluster.name
  location   = "us-central1-a"

  initial_node_count = 3  # Number of nodes at the start

  node_config {
    machine_type = "e2-medium"
    preemptible  = false  # Set to true for cost savings (optional)
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    service_account = "default"
    labels = {
      environment = "dev"
    }
    tags = ["my-nodegroup1"]
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }
}
