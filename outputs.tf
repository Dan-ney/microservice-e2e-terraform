output "service_account_email" {
  description = "GitHub Actions SA email"
  value       = module.github_terraform_wif.service_account_email
}

output "workload_identity_provider_id" {
  description = "WIF Provider ID"
  value       = module.github_terraform_wif.workload_identity_provider_id
}

# gke
output "cluster_name" {
  description = "GKE cluster name"
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

#jenkins
output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${google_compute_address.jenkins.address}:8080"
}

output "jenkins_ip" {
  description = "Jenkins VM public IP"
  value       = google_compute_address.jenkins.address
}

#artifactRegistry
output "ar_frontend_url" {
  value = module.ar_frontend.repository_url
}

output "ar_auth_api_url" {
  value = module.ar_auth_api.repository_url
}

output "ar_todos_api_url" {
  value = module.ar_todos_api.repository_url
}

output "ar_users_api_url" {
  value = module.ar_users_api.repository_url
}

output "ar_log_processor_url" {
  value = module.ar_log_processor.repository_url
}

#argoCD
output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = "argocd"
}
