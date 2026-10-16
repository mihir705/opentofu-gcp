resource "google_filestore_instance" "instance" {
  project  = var.project_id
  name     = var.name
  location = var.location
  tier     = var.tier

  file_shares {
    name        = "share1"
    capacity_gb = var.capacity_gb
  }

  networks {
    network           = var.network
    modes             = ["MODE_IPV4"]
    reserved_ip_range = var.reserved_ip_range
  }

  labels = var.labels
}
