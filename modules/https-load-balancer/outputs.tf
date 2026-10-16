output "instance_group_self_link" {
  description = "Inline instance group self link when created."
  value       = try(google_compute_instance_group.backends[0].self_link, null)
}

output "global_address" {
  description = "Global static IP address."
  value       = google_compute_global_address.address.address
}

output "backend_service_id" {
  description = "Backend service ID when using instance group backends."
  value       = try(google_compute_backend_service.backend[0].id, null)
}

output "backend_bucket_id" {
  description = "Backend bucket ID when using Cloud CDN backend."
  value       = var.backend_bucket
}

output "url_map_id" {
  description = "URL map ID."
  value       = google_compute_url_map.url_map.id
}

output "certificate_id" {
  description = "Managed SSL certificate ID."
  value       = google_compute_managed_ssl_certificate.certificate.id
}

output "forwarding_rule_id" {
  description = "Global HTTPS forwarding rule ID."
  value       = google_compute_global_forwarding_rule.forwarding_rule.id
}
