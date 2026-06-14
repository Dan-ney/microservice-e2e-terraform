module "ar_frontend" {
  source = "./modules/artifact-registry"

  project_id    = var.project_id
  region        = var.region
  repository_id = "frontend"
  description   = "Docker images for frontend service"

  depends_on = [google_project_service.required_apis]
}

module "ar_auth_api" {
  source = "./modules/artifact-registry"

  project_id    = var.project_id
  region        = var.region
  repository_id = "auth-api"
  description   = "Docker images for auth-api service"

  depends_on = [google_project_service.required_apis]
}

module "ar_todos_api" {
  source = "./modules/artifact-registry"

  project_id    = var.project_id
  region        = var.region
  repository_id = "todos-api"
  description   = "Docker images for todos-api service"

  depends_on = [google_project_service.required_apis]
}

module "ar_users_api" {
  source = "./modules/artifact-registry"

  project_id    = var.project_id
  region        = var.region
  repository_id = "users-api"
  description   = "Docker images for users-api service"

  depends_on = [google_project_service.required_apis]
}

module "ar_log_processor" {
  source = "./modules/artifact-registry"

  project_id    = var.project_id
  region        = var.region
  repository_id = "log-message-processor"
  description   = "Docker images for log-message-processor service"

  depends_on = [google_project_service.required_apis]
}
