variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Globally unique bucket name."
  type        = string
}

variable "location" {
  description = "Bucket location (region or multi-region, e.g. US, EU, us-central1)."
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "Default storage class."
  type        = string
  default     = "STANDARD"
}

variable "force_destroy" {
  description = "Delete all objects when the bucket is destroyed."
  type        = bool
  default     = false
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access."
  type        = bool
  default     = true
}

variable "public_access_prevention" {
  description = "Public access prevention setting (enforced or inherited)."
  type        = string
  default     = "enforced"
}

variable "versioning_enabled" {
  description = "Enable object versioning."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels applied to the bucket."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the bucket."
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                        = optional(number)
      created_before             = optional(string)
      with_state                 = optional(string)
      matches_storage_class      = optional(list(string))
      num_newer_versions         = optional(number)
      days_since_noncurrent_time = optional(number)
    })
  }))
  default = []
}

variable "cors" {
  description = "CORS configuration blocks."
  type = list(object({
    origin          = list(string)
    method          = list(string)
    response_header = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "encryption_kms_key_name" {
  description = "Cloud KMS key resource name for bucket encryption. Null for Google-managed encryption."
  type        = string
  default     = null
}
