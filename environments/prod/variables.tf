variable "gcp_project_id" {
  description = "Default GCP project ID for resources when project_key is not used."
  type        = string
}

variable "gcp_region" {
  description = "Primary GCP region where regional resources are created."
  type        = string
  default     = "us-central1"
}

variable "gcp_replica_region" {
  description = "Secondary GCP region for geo-redundant resources."
  type        = string
  default     = "us-east1"
}

variable "default_labels" {
  description = "Default labels applied to all resources."
  type        = map(string)
  default     = {}
}

variable "projects" {
  description = "Projects with optional API enablement. Omit when not managing project services."
  type = map(object({
    project_id = string
    services   = optional(list(string), [])
  }))
  default = {}
}

variable "cloud_storage_buckets" {
  description = "Cloud Storage buckets to create. Omit when not managing buckets."
  type        = map(any)
  default     = {}
}

variable "secret_manager_secrets" {
  description = "Secret Manager secrets to create."
  type        = map(any)
  default     = {}
}

variable "kms_keys" {
  description = "Cloud KMS key rings and crypto keys to create."
  type        = map(any)
  default     = {}
}

variable "vpcs" {
  description = "VPC networks to create."
  type        = map(any)
  default     = {}
}

variable "firewall_rules" {
  description = "Standalone VPC firewall rules to create."
  type        = map(any)
  default     = {}
}

variable "load_balancers" {
  description = "Regional TCP/UDP load balancers to create."
  type        = map(any)
  default     = {}
}

variable "https_load_balancers" {
  description = "Global HTTPS load balancers to create."
  type        = map(any)
  default     = {}
}

variable "cloud_functions" {
  description = "Cloud Functions (2nd gen) to create."
  type        = map(any)
  default     = {}
}

variable "cloud_cdn_backends" {
  description = "Cloud CDN backend buckets to create."
  type        = map(any)
  default     = {}
}

variable "artifact_registries" {
  description = "Artifact Registry repositories to create."
  type        = map(any)
  default     = {}
}

variable "iam_service_accounts" {
  description = "Service accounts and project IAM bindings."
  type        = map(any)
  default     = {}
}

variable "compute_instances" {
  description = "Compute Engine VM instances to create."
  type        = map(any)
  default     = {}
}

variable "cloud_sql_instances" {
  description = "Cloud SQL PostgreSQL instances to create."
  type        = map(any)
  default     = {}
}

variable "api_gateways" {
  description = "API Gateway APIs and gateways to create."
  type        = map(any)
  default     = {}
}

variable "pubsub_topics" {
  description = "Pub/Sub topics to create."
  type        = map(any)
  default     = {}
}

variable "pubsub_subscriptions" {
  description = "Pub/Sub subscriptions to create."
  type        = map(any)
  default     = {}
}

variable "gke_clusters" {
  description = "GKE clusters to create."
  type        = map(any)
  default     = {}
}

variable "cloud_run_services" {
  description = "Cloud Run services to create."
  type        = map(any)
  default     = {}
}

variable "filestore_instances" {
  description = "Filestore instances to create."
  type        = map(any)
  default     = {}
}
