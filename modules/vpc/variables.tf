variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range for VPC subnet"
  type        = string
}

variable "pods_cidr" {
  description = "CIDR range for GKE pods"
  type        = string
}

variable "services_cidr" {
  description = "CIDR range for GKE services"
  type        = string
}
