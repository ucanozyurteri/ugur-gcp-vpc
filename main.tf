# VPC
# resource "google_compute_network" "vpc_network" {
#   name                    = "vpc_network"
#   auto_create_subnetworks = false
#   project                 = "gcpproject"
#   routing_mode            = "GLOBAL"
# }

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}


# Subnets
resource "google_compute_subnetwork" "public1" {
  name          = "public1"
  ip_cidr_range = var.public1_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}
resource "google_compute_subnetwork" "public2" {
  name          = "public2"
  ip_cidr_range = var.public2_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "public3" {
  name          = "public3"
  ip_cidr_range = var.public3_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "private1" {
  name          = "private1"
  ip_cidr_range = var.private1_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "private2" {
  name          = "private2"
  ip_cidr_range = var.private2_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "private3" {
  name          = "private3"
  ip_cidr_range = var.private3_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Router
resource "google_compute_router" "router" {
  name                          = "router"
  network                       = google_compute_network.vpc_network.id
  region = var.region  
  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}

# NAT Gateway
resource "google_compute_router_nat" "nat" {
  name                   = "nat"
  router                 = google_compute_router.router.name
  region                 = google_compute_router.router.region
  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = "private1"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    name                    = "private2"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    name                    = "private3"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Firewall
resource "google_compute_firewall" "allow_http" {
  name          = "allow-http"
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22", "3306"]
  }
}


# provider "google" {
#   credentials = file("serviceaccount.json")
#   project     = "team-3-vpc"
#   region      = "us-central1"
# }

# resource "google_compute_network" "vpc_network" {
#   name = "vpc-network"
# }
