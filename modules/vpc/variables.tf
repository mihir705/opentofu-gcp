variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "VPC network name prefix."
  type        = string
}

variable "region" {
  description = "Primary GCP region for regional resources (Cloud NAT, subnets)."
  type        = string
}

variable "routing_mode" {
  description = "VPC routing mode (REGIONAL or GLOBAL)."
  type        = string
  default     = "REGIONAL"
}

variable "public_subnets" {
  description = "Public subnets keyed by logical name."
  type = map(object({
    region        = string
    ip_cidr_range = string
  }))
}

variable "private_subnets" {
  description = "Private subnets keyed by logical name."
  type = map(object({
    region        = string
    ip_cidr_range = string
  }))
}

variable "enable_cloud_nat" {
  description = "Create Cloud NAT for private subnet egress."
  type        = bool
  default     = true
}

variable "nat_ip_allocate_option" {
  description = "Cloud NAT IP allocation (AUTO_ONLY or MANUAL_ONLY)."
  type        = string
  default     = "AUTO_ONLY"
}

variable "create_public_firewall" {
  description = "Create a default firewall for public subnets (HTTP/HTTPS)."
  type        = bool
  default     = true
}

variable "create_private_firewall" {
  description = "Create a default firewall allowing intra-VPC traffic to private subnets."
  type        = bool
  default     = true
}

variable "public_firewall_source_ranges" {
  description = "Source ranges allowed to reach public subnet targets on HTTP/HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
