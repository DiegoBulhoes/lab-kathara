resource "google_compute_instance" "kathara" {
  name         = "kathara-1"
  machine_type = "n1-standard-1"
  tags         = ["kathara"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }
  metadata = {
    ssh-keys = "${var.user_name}:${file(var.key_ssh)}"
  }

  network_interface {
    subnetwork = var.public_subnetwork
    access_config {
    }
  }
}