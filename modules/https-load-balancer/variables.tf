variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "HTTPS load balancer name prefix."
  type        = string
}

variable "region" {
  description = "Region for regional backend resources."
  type        = string
}

variable "domains" {
  description = "Domains for the managed SSL certificate."
  type        = list(string)
  default     = ["example.com"]
}

variable "backend_port" {
  description = "Backend service port."
  type        = number
  default     = 80
}

variable "backend_instance_groups" {
  description = "Unmanaged or managed instance group self links for backends."
  type        = list(string)
  default     = []
}

variable "backend_instances" {
  description = "Compute instance self links used to build a dedicated instance group when backend_instance_groups is empty."
  type        = list(string)
  default     = []
}

variable "backend_bucket" {
  description = "Backend bucket ID for Cloud CDN static content (mutually exclusive with instance backends)."
  type        = string
  default     = null
}

variable "backend_service" {
  description = "Optional backend service overrides."
  type = object({
    protocol                        = optional(string, "HTTP")
    timeout_sec                     = optional(number, 30)
    connection_draining_timeout_sec = optional(number, 0)
  })
  default = {}
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
