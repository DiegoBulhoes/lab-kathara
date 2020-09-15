
resource "google_compute_network" "vpc_network" {
  name = "${var.project}-network"
}

resource "google_compute_firewall" "firewall_pub_ingress_kathara" {
  name        = "${var.project}-firewall-public-ingress"
  network     = google_compute_network.vpc_network.id
  target_tags = ["kathara"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.port_firewall_public
  }

  depends_on = [google_compute_network.vpc_network]
}
