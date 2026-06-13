output "vpc_name" {
  description = "VPC name"
  value       = google_compute_network.vpc.name
}

output "vpc_id" {
  description = "VPC ID"
  value       = google_compute_network.vpc.id
}

output "subnet_name" {
  description = "Subnet name"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_id" {
  description = "Subnet ID"
  value       = google_compute_subnetwork.subnet.id
}

output "pods_range_name" {
  description = "Secondary range name for pods"
  value       = "pods"
}

output "services_range_name" {
  description = "Secondary range name for services"
  value       = "services"
}
