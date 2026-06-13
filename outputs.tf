output "service_account_email" {
  description = "GitHub Actions SA email"
  value       = module.github_terraform_wif.service_account_email
}

output "workload_identity_provider_id" {
  description = "WIF Provider ID"
  value       = module.github_terraform_wif.workload_identity_provider_id
}
