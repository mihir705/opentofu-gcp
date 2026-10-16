output "vpc_id" {
  description = "VPC network ID."
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "VPC network name."
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "VPC network self link."
  value       = google_compute_network.vpc.self_link
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by logical name."
  value       = { for key, subnet in google_compute_subnetwork.public : key => subnet.id }
}

output "private_subnet_ids" {
  description = "Private subnet IDs keyed by logical name."
  value       = { for key, subnet in google_compute_subnetwork.private : key => subnet.id }
}

output "public_subnet_self_links" {
  description = "Public subnet self links keyed by logical name."
  value       = { for key, subnet in google_compute_subnetwork.public : key => subnet.self_link }
}

output "private_subnet_self_links" {
  description = "Private subnet self links keyed by logical name."
  value       = { for key, subnet in google_compute_subnetwork.private : key => subnet.self_link }
}

output "cloud_nat_enabled" {
  description = "Whether Cloud NAT was created."
  value       = var.enable_cloud_nat
}

output "router_names" {
  description = "Cloud Router names keyed by region."
  value       = { for region, router in google_compute_router.nat : region => router.name }
}
