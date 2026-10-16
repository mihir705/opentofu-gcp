output "service_id" {
  description = "Cloud Run service ID."
  value       = google_cloud_run_v2_service.service.id
}

output "service_name" {
  description = "Cloud Run service name."
  value       = google_cloud_run_v2_service.service.name
}

output "service_uri" {
  description = "Cloud Run service URI."
  value       = google_cloud_run_v2_service.service.uri
}

output "latest_ready_revision" {
  description = "Latest ready revision name."
  value       = google_cloud_run_v2_service.service.latest_ready_revision
}
