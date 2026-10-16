# Artifact Registry Module

Creates a Google Artifact Registry repository.

## Usage

```hcl
module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id    = "my-project"
  location      = "us-central1"
  repository_id = "app-images"
  format        = "DOCKER"
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
