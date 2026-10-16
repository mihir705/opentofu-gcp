output "topic_id" {
  description = "Pub/Sub topic ID."
  value       = google_pubsub_topic.topic.id
}

output "topic_name" {
  description = "Pub/Sub topic name."
  value       = google_pubsub_topic.topic.name
}

output "topic_self_link" {
  description = "Pub/Sub topic self link."
  value       = google_pubsub_topic.topic.id
}
