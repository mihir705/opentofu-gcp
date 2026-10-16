output "instance_id" {
  description = "Cloud SQL instance ID."
  value       = google_sql_database_instance.instance.id
}

output "instance_name" {
  description = "Cloud SQL instance name."
  value       = google_sql_database_instance.instance.name
}

output "connection_name" {
  description = "Cloud SQL connection name."
  value       = google_sql_database_instance.instance.connection_name
}

output "private_ip_address" {
  description = "Private IP address when private_network is configured."
  value       = google_sql_database_instance.instance.private_ip_address
}

output "public_ip_address" {
  description = "Public IP address when private_network is not configured."
  value       = google_sql_database_instance.instance.public_ip_address
}

output "database_name" {
  description = "Created database name when database_name is set."
  value       = try(google_sql_database.database[0].name, null)
}

output "root_password" {
  description = "Root password for the instance."
  value       = local.root_password
  sensitive   = true
}
