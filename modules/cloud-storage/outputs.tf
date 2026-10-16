output "bucket_id" {
  description = "Bucket resource ID."
  value       = google_storage_bucket.bucket.id
}

output "bucket_name" {
  description = "Bucket name."
  value       = google_storage_bucket.bucket.name
}

output "bucket_url" {
  description = "Base URL of the bucket (gs://...)."
  value       = google_storage_bucket.bucket.url
}

output "bucket_self_link" {
  description = "Bucket self link."
  value       = google_storage_bucket.bucket.self_link
}

output "versioning_enabled" {
  description = "Whether object versioning is enabled."
  value       = var.versioning_enabled
}
