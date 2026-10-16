variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Load balancer name prefix."
  type        = string
}

variable "region" {
  description = "Regional load balancer region."
  type        = string
}

variable "network" {
  description = "VPC network self link (unused for external regional NLB; kept for compatibility)."
  type        = string
  default     = null
}

variable "subnet" {
  description = "Subnet self link (unused for external regional NLB; kept for compatibility)."
  type        = string
  default     = null
}

variable "protocol" {
  description = "Backend and forwarding rule protocol (TCP or UDP)."
  type        = string
  default     = "TCP"

  validation {
    condition     = contains(["TCP", "UDP"], var.protocol)
    error_message = "protocol must be TCP or UDP."
  }
}

variable "port" {
  description = "Frontend and backend port."
  type        = number
  default     = 80
}

variable "backend_instance_groups" {
  description = "Unmanaged instance group self links for backends."
  type        = list(string)
  default     = []
}

variable "backend_instances" {
  description = "Compute instance self links used to build an unmanaged instance group when backend_instance_groups is empty."
  type        = list(string)
  default     = []
}

variable "health_check_port" {
  description = "TCP health check port."
  type        = number
  default     = null
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
