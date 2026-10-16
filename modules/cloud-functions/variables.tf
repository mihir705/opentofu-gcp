variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Cloud Function name."
  type        = string
}

variable "location" {
  description = "Cloud Function region."
  type        = string
}

variable "runtime" {
  description = "Function runtime (e.g. python312, nodejs20)."
  type        = string
}

variable "entry_point" {
  description = "Function entry point."
  type        = string
}

variable "source_dir" {
  description = "Local source directory to zip and upload."
  type        = string
  default     = null
}

variable "source_bucket" {
  description = "GCS bucket for function source archive."
  type        = string
  default     = null
}

variable "source_object" {
  description = "GCS object name for function source when source_dir is not used."
  type        = string
  default     = null
}

variable "service_account_email" {
  description = "Runtime service account email."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to the function."
  type        = map(string)
  default     = {}
}
