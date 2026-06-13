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
