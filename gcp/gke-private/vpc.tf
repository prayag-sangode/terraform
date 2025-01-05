# Create VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc"
  auto_create_subnetworks  = false
}

# Public Subnet 1
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "public-subnet-1"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"
  private_ip_google_access = false
}

# Public Subnet 2
resource "google_compute_subnetwork" "public_subnet_2" {
  name          = "public-subnet-2"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.1.0/24"
  private_ip_google_access = false
}

# Private Subnet 1
resource "google_compute_subnetwork" "private_subnet_1" {
  name          = "private-subnet-1"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.2.0/24"
  private_ip_google_access = true
}

# Private Subnet 2
resource "google_compute_subnetwork" "private_subnet_2" {
  name          = "private-subnet-2"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.3.0/24"
  private_ip_google_access = true
}

# Create NAT Router (For private subnets to access the internet)
resource "google_compute_router" "nat_router" {
  name    = "my-nat-router"
  region  = "us-central1"
  network = google_compute_network.vpc_network.id
}

# Create NAT Gateway (For private subnets to access the internet)
resource "google_compute_router_nat" "nat" {
  name                     = "my-nat"
  router                   = google_compute_router.nat_router.name
  region                   = "us-central1"
  nat_ip_allocate_option   = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

