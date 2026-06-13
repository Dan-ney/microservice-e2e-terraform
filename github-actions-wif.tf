module "github_terraform_wif" {
  source           = "./modules/github-actions-wif"
  project_id       = var.project_id
  github_repo_name = "microservice-e2e-terraform"
  project_roles = [
    "${var.project_id}=>roles/editor",
    "${var.project_id}=>roles/resourcemanager.projectIamAdmin",
  ]
  depends_on = [google_project_service.required_apis]
}
