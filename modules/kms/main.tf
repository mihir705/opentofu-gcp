resource "google_kms_key_ring" "key_ring" {
  name     = var.key_ring_name
  location = var.location
  project  = var.project_id
}

resource "google_kms_crypto_key" "key" {
  name     = var.crypto_key_name
  key_ring = google_kms_key_ring.key_ring.id
  purpose  = var.purpose

  rotation_period = var.rotation_period

  labels = var.labels
}
