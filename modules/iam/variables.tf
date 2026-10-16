variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "account_id" {
  description = "Service account ID (short name, 6-30 chars)."
  type        = string
}

variable "display_name" {
  description = "Service account display name."
  type        = string
  default     = null
}

variable "roles" {
  description = "Project IAM roles to grant to the service account."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
