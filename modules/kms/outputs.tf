output "key_ring_id" {
  description = "Key ring ID."
  value       = google_kms_key_ring.key_ring.id
}

output "crypto_key_id" {
  description = "Crypto key ID."
  value       = google_kms_crypto_key.key.id
}

output "crypto_key_name" {
  description = "Full crypto key resource name."
  value       = google_kms_crypto_key.key.name
}
