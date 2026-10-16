variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "location" {
  description = "Artifact Registry location (region or multi-region)."
  type        = string
}

variable "repository_id" {
  description = "Artifact Registry repository ID."
  type        = string
}

variable "format" {
  description = "Repository format (DOCKER, MAVEN, NPM, etc.)."
  type        = string
  default     = "DOCKER"
}

variable "labels" {
  description = "Labels applied to the repository."
  type        = map(string)
  default     = {}
}
