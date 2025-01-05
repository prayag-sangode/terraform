data "google_container_engine_versions" "available_versions" {
  location = "us-central1"
}

resource "google_container_cluster" "gke_cluster" {
  name               = "my-gke-cluster"
  location           = "us-central1-a"
  initial_node_count = 1
  node_version       = data.google_container_engine_versions.available_versions.latest_master_version
  min_master_version = data.google_container_engine_versions.available_versions.latest_master_version

  deletion_protection = false  # Ensure deletion protection is disabled

  # Networking
  network            = google_compute_network.vpc_network.id
  subnetwork         = google_compute_subnetwork.private_subnet_1.id

  # Enable private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip}/32"
      display_name = "Bastion Host"
    }
  }
}

# Node Pool Configuration
resource "google_container_node_pool" "default_node_pool" {
  cluster        = google_container_cluster.gke_cluster.name
  location       = "us-central1-a"
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    service_account = "default"
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}
