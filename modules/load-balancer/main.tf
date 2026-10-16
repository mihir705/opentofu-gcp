locals {
  health_check_port = coalesce(var.health_check_port, var.port)
  use_inline_group  = length(var.backend_instance_groups) == 0 && length(var.backend_instances) > 0
}

resource "google_compute_instance_group" "backends" {
  count = local.use_inline_group ? 1 : 0

  project = var.project_id
  name    = "${var.name}-ig"
  zone    = regex("zones/([^/]+)", var.backend_instances[0])[0]

  instances = var.backend_instances

  named_port {
    name = "http"
    port = var.port
  }
}

locals {
  backend_groups = length(var.backend_instance_groups) > 0 ? var.backend_instance_groups : (
    local.use_inline_group ? [google_compute_instance_group.backends[0].self_link] : []
  )
}

check "backend_required" {
  assert {
    condition     = length(local.backend_groups) > 0
    error_message = "Provide backend_instance_groups or backend_instances."
  }
}

resource "google_compute_region_health_check" "health_check" {
  project = var.project_id
  name    = "${var.name}-hc"
  region  = var.region

  tcp_health_check {
    port = local.health_check_port
  }
}

resource "google_compute_region_backend_service" "backend" {
  project = var.project_id
  name    = "${var.name}-backend"
  region  = var.region

  protocol              = var.protocol
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.health_check.id]

  dynamic "backend" {
    for_each = local.backend_groups
    content {
      group           = backend.value
      balancing_mode  = "CONNECTION"
    }
  }
}

resource "google_compute_forwarding_rule" "forwarding_rule" {
  project = var.project_id
  name    = "${var.name}-fr"
  region  = var.region

  load_balancing_scheme = "EXTERNAL"
  backend_service       = google_compute_region_backend_service.backend.id
  ip_protocol           = var.protocol
  ports                 = [tostring(var.port)]
}
