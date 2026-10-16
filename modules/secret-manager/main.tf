resource "random_password" "secret" {
  count = var.generate_random_password != null ? 1 : 0

  length           = try(var.generate_random_password.length, 32)
  special          = try(var.generate_random_password.special, true)
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  secret_payload = var.generate_random_password != null ? random_password.secret[0].result : var.secret_value
}

check "secret_payload_required" {
  assert {
    condition     = local.secret_payload != null && local.secret_payload != ""
    error_message = "Either secret_value or generate_random_password must be provided."
  }
}

resource "google_secret_manager_secret" "secret" {
  project   = var.project_id
  secret_id = var.secret_id

  dynamic "replication" {
    for_each = length(var.replication_locations) == 0 ? [1] : []
    content {
      auto {}
    }
  }

  dynamic "replication" {
    for_each = length(var.replication_locations) > 0 ? [1] : []
    content {
      dynamic "user_managed" {
        for_each = [1]
        content {
          dynamic "replicas" {
            for_each = var.replication_locations
            content {
              location = replicas.value
            }
          }
        }
      }
    }
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = local.secret_payload
}
