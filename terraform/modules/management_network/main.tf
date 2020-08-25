
resource "google_compute_network" "vpc_network" {
  name                    = "${var.project}-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "public_subnetwork" {
  name          = "${var.project}-public-subnet"
  ip_cidr_range = var.ip_cidr_range_public
  network       = google_compute_network.vpc_network.id
  region        = var.region
  depends_on    = [google_compute_network.vpc_network]
}

resource "google_compute_firewall" "firewall_public_subnet" {
  name    = "${var.project}-firewall-public"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.port_firewall_public
  }
  source_ranges = ["0.0.0.0/0"]
  depends_on    = [google_compute_network.vpc_network]
}