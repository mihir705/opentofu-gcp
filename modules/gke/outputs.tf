output "cluster_id" {
  description = "GKE cluster ID."
  value       = google_container_cluster.cluster.id
}

output "cluster_name" {
  description = "GKE cluster name."
  value       = google_container_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "GKE cluster API endpoint."
  value       = google_container_cluster.cluster.endpoint
}

output "cluster_location" {
  description = "GKE cluster location."
  value       = google_container_cluster.cluster.location
}

output "node_pool_name" {
  description = "Primary node pool name."
  value       = google_container_node_pool.primary.name
}
