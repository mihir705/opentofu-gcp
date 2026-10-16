locals {
  node_pool_name = try(var.node_pool.name, "default-pool")
  node_location  = var.location
}

resource "google_container_cluster" "cluster" {
  project  = var.project_id
  name     = var.name
  location = var.location

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  network    = var.network
  subnetwork = var.subnetwork

  resource_labels = var.labels

  deletion_protection = var.deletion_protection

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

resource "google_container_node_pool" "primary" {
  project  = var.project_id
  name     = local.node_pool_name
  location = local.node_location
  cluster  = google_container_cluster.cluster.name

  node_count = try(var.node_pool.node_count, 1)

  node_locations = try(var.node_pool.node_locations, null)

  dynamic "autoscaling" {
    for_each = try(var.node_pool.min_node_count, null) != null && try(var.node_pool.max_node_count, null) != null ? [1] : []
    content {
      min_node_count = var.node_pool.min_node_count
      max_node_count = var.node_pool.max_node_count
    }
  }

  node_config {
    machine_type    = try(var.node_pool.machine_type, "e2-medium")
    disk_size_gb    = try(var.node_pool.disk_size_gb, 100)
    disk_type       = try(var.node_pool.disk_type, "pd-balanced")
    preemptible     = try(var.node_pool.preemptible, false)
    service_account = try(var.node_pool.service_account, null)
    oauth_scopes    = try(var.node_pool.oauth_scopes, ["https://www.googleapis.com/auth/cloud-platform"])

    labels = var.labels
  }

  management {
    auto_repair  = try(var.node_pool.auto_repair, true)
    auto_upgrade = try(var.node_pool.auto_upgrade, true)
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}
