output "enabled_services" {
  description = "API services enabled on the project."
  value       = [for svc in google_project_service.service : svc.service]
}

output "project_id" {
  description = "GCP project ID."
  value       = var.project_id
}
