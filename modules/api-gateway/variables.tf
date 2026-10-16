variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "api_id" {
  description = "API Gateway API ID."
  type        = string
}

variable "gateway_id" {
  description = "API Gateway gateway ID."
  type        = string
}

variable "region" {
  description = "Gateway region."
  type        = string
}

variable "openapi_spec" {
  description = "Inline OpenAPI specification. Uses a placeholder when null."
  type        = string
  default     = null
}

variable "backend_address" {
  description = "Backend URL for the placeholder OpenAPI spec (e.g. Cloud Run service URI)."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to supported resources."
  type        = map(string)
  default     = {}
}
