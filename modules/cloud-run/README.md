# Cloud Run Module

Creates a Cloud Run v2 service.

## Usage

```hcl
module "cloud_run" {
  source = "../../modules/cloud-run"

  project_id = "my-project"
  name       = "app-api"
  location   = "us-central1"
  image      = "us-docker.pkg.dev/my-project/app/app:latest"
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
