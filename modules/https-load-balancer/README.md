# HTTPS Load Balancer Module

Creates a global HTTPS load balancer with a Google-managed SSL certificate. Supports instance group backends or a Cloud CDN backend bucket via `backend_bucket`.

## Usage

```hcl
module "https_load_balancer" {
  source = "../../modules/https-load-balancer"

  project_id     = "my-project"
  name           = "app-https"
  region         = "us-central1"
  domains        = ["app.example.com"]
  backend_bucket = module.cloud_cdn.backend_bucket_id
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
