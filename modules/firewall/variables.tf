variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Firewall rule name prefix."
  type        = string
}

variable "network" {
  description = "VPC network name or self link."
  type        = string
}

variable "description" {
  description = "Default description applied to firewall rules."
  type        = string
  default     = null
}

variable "direction" {
  description = "Default traffic direction (INGRESS or EGRESS) when a rule omits direction."
  type        = string
  default     = "INGRESS"

  validation {
    condition     = contains(["INGRESS", "EGRESS"], var.direction)
    error_message = "direction must be INGRESS or EGRESS."
  }
}

variable "priority" {
  description = "Default rule priority."
  type        = number
  default     = 1000
}

variable "ingress_rules" {
  description = "Ingress firewall rules keyed by logical name."
  type = map(object({
    description   = optional(string)
    priority      = optional(number)
    source_ranges = optional(list(string))
    source_tags   = optional(list(string))
    allow = list(object({
      protocol = string
      ports    = optional(list(string))
    }))
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
  default = {}
}

variable "egress_rules" {
  description = "Egress firewall rules keyed by logical name."
  type = map(object({
    description          = optional(string)
    priority             = optional(number)
    destination_ranges = optional(list(string))
    allow = list(object({
      protocol = string
      ports    = optional(list(string))
    }))
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
  default = {}
}

variable "target_tags" {
  description = "Network tags applied to all firewall rules."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
