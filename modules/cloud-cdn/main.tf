resource "google_compute_backend_bucket" "cdn" {
  project     = var.project_id
  name        = "${var.name}-cdn-backend"
  bucket_name = var.bucket_name
  enable_cdn  = var.enable_cdn

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    default_ttl       = 3600
    client_ttl        = 3600
    max_ttl           = 86400
    negative_caching  = true
    serve_while_stale = 86400
  }
}
