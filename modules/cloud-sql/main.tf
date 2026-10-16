resource "random_password" "root" {
  count = var.generate_password != null ? 1 : 0

  length           = try(var.generate_password.length, 16)
  special          = try(var.generate_password.special, true)
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  root_password = var.generate_password != null ? random_password.root[0].result : var.root_password
}

resource "google_sql_database_instance" "instance" {
  project          = var.project_id
  name             = var.name
  database_version = var.database_version
  region           = var.region

  settings {
    tier      = var.tier
    disk_size = var.disk_size

    user_labels = var.labels

    ip_configuration {
      ipv4_enabled    = var.private_network == null
      private_network = var.private_network
    }
  }

  root_password = local.root_password

  deletion_protection = var.deletion_protection
}

resource "google_sql_database" "database" {
  count = var.database_name != null ? 1 : 0

  project  = var.project_id
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}
