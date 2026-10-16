# Cloud Functions Module

Creates a Cloud Functions (2nd gen) function from a local directory or GCS object.

## Usage

```hcl
module "cloud_functions" {
  source = "../../modules/cloud-functions"

  project_id    = "my-project"
  name          = "app-handler"
  location      = "us-central1"
  runtime       = "python312"
  entry_point   = "main"
  source_dir    = "${path.module}/function"
  source_bucket = "my-project-functions"
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
