locals {
  topic = var.topic_id != null ? var.topic_id : "projects/${var.project_id}/topics/${var.topic_name}"
}

check "topic_reference_required" {
  assert {
    condition     = var.topic_id != null || var.topic_name != null
    error_message = "Either topic_id or topic_name must be provided."
  }
}

resource "google_pubsub_subscription" "subscription" {
  project = var.project_id
  name    = var.name
  topic   = local.topic

  ack_deadline_seconds = var.ack_deadline_seconds
  labels               = var.labels
}
