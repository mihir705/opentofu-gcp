variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "GKE cluster name."
  type        = string
}

variable "location" {
  description = "Cluster location (region or zone)."
  type        = string
}

variable "region" {
  description = "Primary region for regional node pools."
  type        = string
  default     = null
}

variable "network" {
  description = "VPC network name or self link."
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name or self link."
  type        = string
}

variable "initial_node_count" {
  description = "Initial node count for the default node pool (removed after creation)."
  type        = number
  default     = 1
}

variable "node_pool" {
  description = "Node pool configuration."
  type = object({
    name               = optional(string, "default-pool")
    node_count         = optional(number, 1)
    machine_type       = optional(string, "e2-medium")
    disk_size_gb       = optional(number, 100)
    disk_type          = optional(string, "pd-balanced")
    preemptible        = optional(bool, false)
    service_account    = optional(string)
    oauth_scopes       = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])
    auto_repair        = optional(bool, true)
    auto_upgrade       = optional(bool, true)
    min_node_count     = optional(number)
    max_node_count     = optional(number)
    node_locations     = optional(list(string))
  })
  default = {}
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "When true, Terraform cannot destroy the cluster."
  type        = bool
  default     = false
}
