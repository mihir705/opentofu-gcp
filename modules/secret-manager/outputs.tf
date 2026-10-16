output "secret_id" {
  description = "Secret resource ID."
  value       = google_secret_manager_secret.secret.id
}

output "secret_name" {
  description = "Full secret resource name."
  value       = google_secret_manager_secret.secret.name
}

output "secret_version_id" {
  description = "Latest secret version ID."
  value       = google_secret_manager_secret_version.version.id
}
