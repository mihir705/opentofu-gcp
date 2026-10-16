output "service_account_email" {
  description = "Service account email address."
  value       = google_service_account.service_account.email
}

output "service_account_name" {
  description = "Service account resource name."
  value       = google_service_account.service_account.name
}

output "service_account_id" {
  description = "Service account ID."
  value       = google_service_account.service_account.id
}

output "granted_roles" {
  description = "Project roles granted to the service account."
  value       = var.roles
}
