output "subscription_id" {
  description = "Pub/Sub subscription ID."
  value       = google_pubsub_subscription.subscription.id
}

output "subscription_name" {
  description = "Pub/Sub subscription name."
  value       = google_pubsub_subscription.subscription.name
}

output "topic" {
  description = "Linked Pub/Sub topic."
  value       = local.topic
}
