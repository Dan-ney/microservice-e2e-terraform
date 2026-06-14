variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "repository_id" {
  description = "Artifact Registry repository name"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = ""
}
