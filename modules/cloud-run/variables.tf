variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Cloud Run service name."
  type        = string
}

variable "location" {
  description = "Cloud Run region."
  type        = string
}

variable "image" {
  description = "Container image URI."
  type        = string
}

variable "env" {
  description = "Environment variables for the container."
  type        = map(string)
  default     = {}
}

variable "ingress" {
  description = "Ingress settings (INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER)."
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "vpc_connector" {
  description = "Serverless VPC Access connector name or self link."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to the service."
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "When true, Terraform cannot destroy the service."
  type        = bool
  default     = false
}
