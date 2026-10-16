resource "google_compute_managed_ssl_certificate" "certificate" {
  project = var.project_id
  name    = "${var.name}-cert"

  managed {
    domains = var.domains
  }
}

locals {
  use_backend_bucket = var.backend_bucket != null
  use_inline_group   = !local.use_backend_bucket && length(var.backend_instance_groups) == 0 && length(var.backend_instances) > 0
  backend_groups = local.use_backend_bucket ? [] : (
    length(var.backend_instance_groups) > 0 ? var.backend_instance_groups : (
      local.use_inline_group ? [google_compute_instance_group.backends[0].self_link] : []
    )
  )
}

resource "google_compute_instance_group" "backends" {
  count = local.use_inline_group ? 1 : 0

  project = var.project_id
  name    = "${var.name}-ig"
  zone    = regex("zones/([^/]+)", var.backend_instances[0])[0]

  instances = var.backend_instances

  named_port {
    name = "http"
    port = var.backend_port
  }
}

check "backend_required" {
  assert {
    condition     = local.use_backend_bucket || length(local.backend_groups) > 0
    error_message = "Provide backend_bucket, backend_instance_groups, or backend_instances."
  }
}

resource "google_compute_health_check" "health_check" {
  count = local.use_backend_bucket ? 0 : 1

  project = var.project_id
  name    = "${var.name}-hc"

  http_health_check {
    port = var.backend_port
  }
}

resource "google_compute_backend_service" "backend" {
  count = local.use_backend_bucket ? 0 : 1

  project = var.project_id
  name    = "${var.name}-backend"

  protocol    = try(var.backend_service.protocol, "HTTP")
  port_name   = "http"
  timeout_sec = try(var.backend_service.timeout_sec, 30)

  connection_draining_timeout_sec = try(var.backend_service.connection_draining_timeout_sec, 0)
  health_checks                 = [google_compute_health_check.health_check[0].id]

  dynamic "backend" {
    for_each = local.backend_groups
    content {
      group = backend.value
    }
  }
}

resource "google_compute_url_map" "url_map" {
  project = var.project_id
  name    = "${var.name}-url-map"

  default_service = local.use_backend_bucket ? var.backend_bucket : google_compute_backend_service.backend[0].id
}

resource "google_compute_target_https_proxy" "proxy" {
  project = var.project_id
  name    = "${var.name}-https-proxy"

  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.certificate.id]
}

resource "google_compute_global_address" "address" {
  project = var.project_id
  name    = "${var.name}-ip"
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  project = var.project_id
  name    = "${var.name}-https-fr"

  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.address.address
  port_range            = "443"
  target                = google_compute_target_https_proxy.proxy.id
}
