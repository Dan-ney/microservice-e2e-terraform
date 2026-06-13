output "service_account_email" {
  value = module.github_actions_sa.service_accounts_map[local.name].email
}
output "workload_identity_provider_id" {
  value = google_iam_workload_identity_pool_provider.github_actions.name
}
