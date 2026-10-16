resource "google_cloud_run_v2_service" "service" {
  project  = var.project_id
  name     = var.name
  location = var.location
  ingress  = var.ingress

  deletion_protection = var.deletion_protection

  labels = var.labels

  template {
    dynamic "vpc_access" {
      for_each = var.vpc_connector != null ? [var.vpc_connector] : []
      content {
        connector = vpc_access.value
        egress    = "PRIVATE_RANGES_ONLY"
      }
    }

    containers {
      image = var.image

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
}
