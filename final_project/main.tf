provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source = "./modules/network"

  project_id     = var.project_id
  region         = var.region
  instance_group = module.compute.instance_group
}

module "compute" {
  source = "./modules/compute"

  project_id         = var.project_id
  region             = var.region
  network            = module.network.network_self_link
  subnetwork         = module.network.subnetwork_self_link
}