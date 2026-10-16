output "function_id" {
  description = "Cloud Function ID."
  value       = google_cloudfunctions2_function.function.id
}

output "function_name" {
  description = "Cloud Function name."
  value       = google_cloudfunctions2_function.function.name
}

output "function_uri" {
  description = "Cloud Function service URI."
  value       = google_cloudfunctions2_function.function.service_config[0].uri
}

output "source_object" {
  description = "Uploaded source object name."
  value       = local.source_object
}
