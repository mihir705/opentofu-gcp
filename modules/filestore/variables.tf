variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Filestore instance name."
  type        = string
}

variable "location" {
  description = "Filestore zone or region."
  type        = string
}

variable "tier" {
  description = "Filestore service tier (STANDARD, PREMIUM, BASIC_HDD, BASIC_SSD, etc.)."
  type        = string
  default     = "STANDARD"
}

variable "capacity_gb" {
  description = "File share capacity in GB."
  type        = number
  default     = 1024
}

variable "network" {
  description = "VPC network name for the instance."
  type        = string
}

variable "reserved_ip_range" {
  description = "Reserved IP range for the Filestore instance."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
