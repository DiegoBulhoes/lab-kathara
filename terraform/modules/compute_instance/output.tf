output "kathara_public" {
  value = google_compute_instance.kathara.*.network_interface.0.access_config.0.nat_ip
}