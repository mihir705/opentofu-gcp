variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Compute instance name."
  type        = string
}

variable "zone" {
  description = "GCP zone for the instance."
  type        = string
}

variable "machine_type" {
  description = "Machine type (e.g. e2-medium)."
  type        = string
  default     = "e2-medium"
}

variable "subnet_self_link" {
  description = "Subnet self link for the instance network interface."
  type        = string
}

variable "network_tags" {
  description = "Network tags applied to the instance."
  type        = list(string)
  default     = []
}

variable "boot_disk" {
  description = "Boot disk configuration."
  type = object({
    image       = optional(string, "projects/debian-cloud/global/images/family/debian-12")
    size_gb     = optional(number, 20)
    type        = optional(string, "pd-balanced")
    auto_delete = optional(bool, true)
  })
  default = {}
}

variable "metadata" {
  description = "Instance metadata key/value pairs."
  type        = map(string)
  default     = {}
}

variable "service_account_email" {
  description = "Service account email attached to the instance."
  type        = string
  default     = null
}

variable "create_public_ip" {
  description = "Assign an ephemeral external IP address."
  type        = bool
  default     = false
}

variable "generate_password" {
  description = "Generate a random password and store in metadata (windows-password or ssh-keys)."
  type = object({
    metadata_key = optional(string, "windows-password")
    length       = optional(number, 16)
    special      = optional(bool, true)
    ssh_username = optional(string)
  })
  default = null
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
