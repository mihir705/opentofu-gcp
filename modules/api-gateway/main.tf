locals {
  # OpenAPI 2.0: top-level x-google-backend with address (see GCP Cloud Run quickstart).
  placeholder_openapi = <<-EOT
    swagger: '2.0'
    info:
      title: ${var.api_id}
      description: API Gateway with Cloud Run backend
      version: 1.0.0
    schemes:
    - https
    produces:
    - application/json
    x-google-backend:
      address: ${var.backend_address}
      path_translation: APPEND_PATH_TO_ADDRESS
    paths:
      /health:
        get:
          operationId: health
          summary: Health check
          responses:
            '200':
              description: OK
              schema:
                type: string
  EOT

  openapi_documents = {
    placeholder = {
      contents = base64encode(coalesce(var.openapi_spec, local.placeholder_openapi))
      path     = "openapi.yaml"
    }
  }
}

check "backend_address_required" {
  assert {
    condition     = var.openapi_spec != null || var.backend_address != null
    error_message = "backend_address is required when openapi_spec is not provided."
  }
}

resource "google_api_gateway_api" "api" {
  provider = google-beta

  project      = var.project_id
  api_id       = var.api_id
  display_name = var.api_id
}

resource "google_api_gateway_api_config" "config" {
  provider = google-beta

  project      = var.project_id
  api          = google_api_gateway_api.api.api_id
  api_config_id = "${var.api_id}-config"

  openapi_documents {
    document {
      path     = local.openapi_documents.placeholder.path
      contents = local.openapi_documents.placeholder.contents
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "gateway" {
  provider = google-beta

  project      = var.project_id
  region       = var.region
  gateway_id   = var.gateway_id
  api_config   = google_api_gateway_api_config.config.id
  display_name = var.gateway_id
}
