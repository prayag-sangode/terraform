# GKE Cluster Configuration

# Create a GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name               = "my-gke-cluster"
  location           = "us-central1-a"
  initial_node_count = 1
  node_version       = "latest"  # You can specify a GKE version if required

  # Networking
  network            = google_compute_network.vpc_network.id
  subnetwork         = google_compute_subnetwork.private_subnet_1.id

  # Enable private cluster to restrict the control plane to the VPC
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  # Enable master authorized networks and allow access from the Bastion host
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
      display_name = "Bastion Host"
    }
  }
}

# Node Pool Configuration (with machine type and service account)
resource "google_container_node_pool" "default_node_pool" {
  cluster        = google_container_cluster.gke_cluster.name
  location       = "us-central1-a"
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"  # Change as per your requirements
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Use the default service account
    service_account = "default"
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  # Enable private nodes for node pool
  node_pool {
    name               = "default-node-pool"
    initial_node_count = 1

    # Enable private nodes (this makes the nodes not accessible from the public internet)
    management {
      auto_upgrade = true
      auto_repair  = true
    }
  }
}

# Firewall rule for accessing the GKE nodes from the Bastion host
resource "google_compute_firewall" "allow_gke_bastion" {
  name    = "allow-gke-from-bastion"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = [google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip]
  target_tags   = ["gke-node"]
}

# Output the GKE cluster credentials
output "gke_cluster_kubeconfig" {
  value = google_container_cluster.gke_cluster.kube_config_raw
}
