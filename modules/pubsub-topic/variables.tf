variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Pub/Sub topic name."
  type        = string
}

variable "message_retention_duration" {
  description = "Message retention duration (e.g. 86400s)."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to the topic."
  type        = map(string)
  default     = {}
}
