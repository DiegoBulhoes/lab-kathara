resource "google_compute_instance" "kathara" {
  name         = "kathara-1"
  machine_type = var.machine_type
  tags         = ["kathara"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
      size  = "25"
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
