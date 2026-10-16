# API Gateway Module

Creates a Google Cloud API Gateway API, config, and gateway. When `openapi_spec` is omitted, a placeholder OpenAPI 2.0 spec routes `/health` to a Cloud Run backend via `backend_address`.

## Usage

```hcl
module "api_gateway" {
  source = "../../modules/api-gateway"

  project_id       = "my-project"
  api_id           = "app-api"
  gateway_id       = "app-gateway"
  region           = "us-central1"
  backend_address  = "https://app-api-xxxxx-uc.a.run.app"
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
