output "instance_id" {
  description = "Compute instance ID."
  value       = google_compute_instance.instance.id
}

output "instance_name" {
  description = "Compute instance name."
  value       = google_compute_instance.instance.name
}

output "instance_self_link" {
  description = "Compute instance self link."
  value       = google_compute_instance.instance.self_link
}

output "internal_ip" {
  description = "Primary internal IP address."
  value       = google_compute_instance.instance.network_interface[0].network_ip
}

output "external_ip" {
  description = "External IP address when create_public_ip is true."
  value       = try(google_compute_instance.instance.network_interface[0].access_config[0].nat_ip, null)
}

output "generated_password" {
  description = "Generated password when generate_password is set."
  value       = try(random_password.instance[0].result, null)
  sensitive   = true
}
