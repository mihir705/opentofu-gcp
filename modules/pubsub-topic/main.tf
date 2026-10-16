resource "google_pubsub_topic" "topic" {
  project = var.project_id
  name    = var.name

  message_retention_duration = var.message_retention_duration
  labels                     = var.labels
}
