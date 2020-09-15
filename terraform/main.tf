provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "management_network" {
  source               = "./modules/management_network"
  project              = var.project
  zone                 = var.zone
  region               = var.region
  port_firewall_public = var.port_firewall_public
}

module "compute_instance" {
  source            = "./modules/compute_instance"
  project           = var.project
  user_name         = var.user_name
  key_ssh           = var.key_ssh
  machine_type      = var.machine_type
  public_subnetwork = module.management_network.network
}
