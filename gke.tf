module "gke" {
  source = "./modules/gke"

  project_id          = var.project_id
  region              = var.region
  zone                = var.zone
  environment         = var.environment
  network_name        = module.vpc.vpc_name
  subnet_name         = module.vpc.subnet_name
  pods_range_name     = module.vpc.pods_range_name
  services_range_name = module.vpc.services_range_name
  machine_type        = "e2-medium"
  disk_size_gb        = 20
  min_node_count      = 1
  max_node_count      = 2

  depends_on = [
    google_project_service.required_apis,
    module.vpc
  ]
}
