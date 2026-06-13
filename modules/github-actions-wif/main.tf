locals {
  name = trim(substr(
    replace(
      lower("github-actions-${var.github_repo_name}"),
      "/[^a-z0-9-]/",                                  
      "-"
    ),
    0,
    30
  ),"-")
}

module "github_actions_sa" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  project_id   = var.project_id
  names        = [local.name]
  display_name = "GitHub Actions for ${var.github_repo_name}"
  description  = "Service account for GitHub Actions to deploy resources via terraform"

  project_roles = var.project_roles
}

resource "google_iam_workload_identity_pool" "github_actions" {
  workload_identity_pool_id = local.name
  display_name              = local.name
  description               = "Workload Identity Pool for ${var.github_repo_name}"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = local.name
  display_name                       = local.name
  description                        = "OIDC identity provider for ${var.github_repo_name}"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }

  attribute_condition = "attribute.repository == '${var.github_repo_owner}/${var.github_repo_name}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_actions_workload_identity" {
  service_account_id = module.github_actions_sa.service_accounts_map[local.name].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/${var.github_repo_owner}/${var.github_repo_name}"
}
