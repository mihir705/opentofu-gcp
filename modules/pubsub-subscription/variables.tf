variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Pub/Sub subscription name."
  type        = string
}

variable "topic_id" {
  description = "Full Pub/Sub topic ID or self link."
  type        = string
  default     = null
}

variable "topic_name" {
  description = "Short Pub/Sub topic name when topic_id is not provided."
  type        = string
  default     = null
}

variable "ack_deadline_seconds" {
  description = "Acknowledgement deadline in seconds."
  type        = number
  default     = 20
}

variable "labels" {
  description = "Labels applied to the subscription."
  type        = map(string)
  default     = {}
}
