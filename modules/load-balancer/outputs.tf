output "backend_service_id" {
  description = "Regional backend service ID."
  value       = google_compute_region_backend_service.backend.id
}

output "forwarding_rule_id" {
  description = "Regional forwarding rule ID."
  value       = google_compute_forwarding_rule.forwarding_rule.id
}

output "forwarding_rule_ip" {
  description = "Regional forwarding rule IP address."
  value       = google_compute_forwarding_rule.forwarding_rule.ip_address
}

output "health_check_id" {
  description = "Regional health check ID."
  value       = google_compute_region_health_check.health_check.id
}

output "instance_group_self_link" {
  description = "Inline instance group self link when created."
  value       = try(google_compute_instance_group.backends[0].self_link, null)
}
