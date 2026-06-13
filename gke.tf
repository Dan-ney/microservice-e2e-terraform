module "gke" {
  source = "./modules/gke"

  project_id          = var.project_id
  region              = var.region
  zone                = var.zone
  environment         = var.environment
  network_name        = module.network.vpc_name
  subnet_name         = module.network.subnet_name
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name
  machine_type        = "e2-medium"
  disk_size_gb        = 20
  min_node_count      = 1
  max_node_count      = 2

  depends_on = [
    google_project_service.required_apis,
    module.network
  ]
}
