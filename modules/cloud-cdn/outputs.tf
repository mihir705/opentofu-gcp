output "backend_bucket_id" {
  description = "Backend bucket ID."
  value       = google_compute_backend_bucket.cdn.id
}

output "backend_bucket_name" {
  description = "Backend bucket name."
  value       = google_compute_backend_bucket.cdn.name
}

output "cdn_enabled" {
  description = "Whether CDN is enabled."
  value       = google_compute_backend_bucket.cdn.enable_cdn
}
