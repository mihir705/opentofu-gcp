resource "random_password" "instance" {
  count = var.generate_password != null ? 1 : 0

  length           = try(var.generate_password.length, 16)
  special          = try(var.generate_password.special, true)
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  generated_metadata = var.generate_password != null ? (
    try(var.generate_password.ssh_username, null) != null ? {
      ssh-keys = "${var.generate_password.ssh_username}:${random_password.instance[0].result}"
    } : {
      (try(var.generate_password.metadata_key, "windows-password")) = random_password.instance[0].result
    }
  ) : {}

  instance_metadata = merge(var.metadata, local.generated_metadata)
}

resource "google_compute_instance" "instance" {
  project      = var.project_id
  name         = var.name
  zone         = var.zone
  machine_type = var.machine_type
  tags         = var.network_tags

  metadata = local.instance_metadata

  labels = var.labels

  boot_disk {
    auto_delete = var.boot_disk.auto_delete
    initialize_params {
      image = var.boot_disk.image
      size  = var.boot_disk.size_gb
      type  = var.boot_disk.type
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link

    dynamic "access_config" {
      for_each = var.create_public_ip ? [1] : []
      content {}
    }
  }

  dynamic "service_account" {
    for_each = var.service_account_email != null ? [var.service_account_email] : []
    content {
      email  = service_account.value
      scopes = ["cloud-platform"]
    }
  }
}
