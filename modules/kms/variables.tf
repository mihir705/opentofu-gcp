variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "location" {
  description = "Key ring location (region or global)."
  type        = string
}

variable "key_ring_name" {
  description = "Key ring name."
  type        = string
}

variable "crypto_key_name" {
  description = "Crypto key name."
  type        = string
}

variable "purpose" {
  description = "Crypto key purpose."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "rotation_period" {
  description = "Rotation period (e.g. 7776000s for 90 days). Null disables rotation."
  type        = string
  default     = "7776000s"
}

variable "labels" {
  description = "Labels applied to the crypto key."
  type        = map(string)
  default     = {}
}
