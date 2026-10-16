variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Backend bucket name prefix."
  type        = string
}

variable "bucket_name" {
  description = "Existing Cloud Storage bucket name."
  type        = string
}

variable "enable_cdn" {
  description = "Enable Cloud CDN on the backend bucket."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
