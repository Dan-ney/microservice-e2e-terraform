variable "project_id" {
  description = "The ID of the GCP project where resources will be created."
  type        = string
}

variable "project_roles" {
  description = "List of project-level roles to assign to the service account."
  type        = list(string)
}

variable "github_repo_owner" {
  description = "GitHub repository owner (organization or username)."
  type        = string
  default     = "cupid-mapping-inc"
}

variable "github_repo_name" {
  description = "GitHub repository name."
  type        = string
}
