# Cloud CDN Module

Creates a Cloud CDN-enabled backend bucket for static content.

## Usage

```hcl
module "cloud_cdn" {
  source = "../../modules/cloud-cdn"

  project_id  = "my-project"
  name        = "app"
  bucket_name = module.cloud_storage.bucket_name
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
