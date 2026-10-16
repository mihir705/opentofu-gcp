variable "project_id" {
  description = "GCP project ID where APIs are enabled."
  type        = string
}

variable "services" {
  description = "List of Google API service names to enable (e.g. compute.googleapis.com)."
  type        = list(string)
}

variable "disable_on_destroy" {
  description = "Whether to disable services when the Terraform resource is destroyed."
  type        = bool
  default     = false
}
