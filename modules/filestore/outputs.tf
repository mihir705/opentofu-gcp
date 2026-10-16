output "instance_id" {
  description = "Filestore instance ID."
  value       = google_filestore_instance.instance.id
}

output "instance_name" {
  description = "Filestore instance name."
  value       = google_filestore_instance.instance.name
}

output "ip_addresses" {
  description = "Filestore instance IP addresses."
  value       = google_filestore_instance.instance.networks[0].ip_addresses
}

output "mount_name" {
  description = "File share mount name."
  value       = google_filestore_instance.instance.file_shares[0].name
}
