variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "asia-south1-a"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "argocd_workload_identity_name" {
  type        = string
  description = "The name of the Google Cloud Service Account created for ArgoCD"
}

variable "argocd_repo_sa_name" {
  type        = string
  description = "The name of the internal Kubernetes Service Account used by the argo repo server"
}
