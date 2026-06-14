output "repository_url" {
  description = "Full repository URL for docker push/pull"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}

output "repository_id" {
  description = "Repository ID"
  value       = google_artifact_registry_repository.repo.repository_id
}
