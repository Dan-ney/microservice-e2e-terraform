module "network" {
  source = "./modules/vpc"

  project_id    = var.project_id
  region        = var.region
  environment   = var.environment
  vpc_cidr      = "10.0.0.0/16"
  pods_cidr     = "10.1.0.0/16"
  services_cidr = "10.2.0.0/16"

  depends_on = [google_project_service.required_apis]
}
