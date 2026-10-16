variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "secret_id" {
  description = "Secret ID (short name)."
  type        = string
}

variable "secret_value" {
  description = "Plain-text secret payload. Omit when generate_random_password is set."
  type        = string
  default     = null
  sensitive   = true
}

variable "generate_random_password" {
  description = "Generate a random password instead of using secret_value."
  type = object({
    length  = optional(number, 32)
    special = optional(bool, true)
  })
  default = null
}

variable "replication_locations" {
  description = "User-managed replication locations. Empty list uses automatic replication."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels applied to the secret."
  type        = map(string)
  default     = {}
}
