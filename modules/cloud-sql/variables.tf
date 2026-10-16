variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Cloud SQL instance name."
  type        = string
}

variable "region" {
  description = "Primary region for the instance."
  type        = string
}

variable "tier" {
  description = "Machine tier (e.g. db-f1-micro)."
  type        = string
  default     = "db-f1-micro"
}

variable "database_version" {
  description = "Database engine version."
  type        = string
  default     = "POSTGRES_15"
}

variable "disk_size" {
  description = "Disk size in GB."
  type        = number
  default     = 10
}

variable "private_network" {
  description = "VPC network self link for private IP connectivity."
  type        = string
  default     = null
}

variable "database_name" {
  description = "Optional database name to create on the instance."
  type        = string
  default     = null
}

variable "generate_password" {
  description = "Generate a random root password."
  type = object({
    length  = optional(number, 16)
    special = optional(bool, true)
  })
  default = null
}

variable "root_password" {
  description = "Root password when generate_password is not set."
  type        = string
  default     = null
  sensitive   = true
}

variable "labels" {
  description = "User labels applied to the instance."
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "When true, Terraform cannot destroy the instance."
  type        = bool
  default     = false
}
