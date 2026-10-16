# Filestore Module

Creates a Google Cloud Filestore instance.

## Usage

```hcl
module "filestore" {
  source = "../../modules/filestore"

  project_id  = "my-project"
  name        = "app-files"
  location    = "us-central1-a"
  network     = module.vpc.vpc_name
  capacity_gb = 1024
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
