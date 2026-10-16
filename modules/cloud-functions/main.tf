data "archive_file" "source" {
  count = var.source_dir != null ? 1 : 0

  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/.build/${var.name}.zip"
}

locals {
  source_bucket = var.source_bucket
  source_object = var.source_dir != null ? "${var.name}-${data.archive_file.source[0].output_md5}.zip" : var.source_object
}

check "source_reference_required" {
  assert {
    condition     = var.source_dir != null || (var.source_bucket != null && var.source_object != null)
    error_message = "Provide source_dir with source_bucket, or source_bucket and source_object."
  }
}

resource "google_storage_bucket_object" "source" {
  count = var.source_dir != null ? 1 : 0

  name   = local.source_object
  bucket = local.source_bucket
  source = data.archive_file.source[0].output_path
}

resource "google_cloudfunctions2_function" "function" {
  project  = var.project_id
  name     = var.name
  location = var.location

  labels = var.labels

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point

    source {
      storage_source {
        bucket = local.source_bucket
        object = local.source_object
      }
    }
  }

  service_config {
    service_account_email = var.service_account_email
  }
}
