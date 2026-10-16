# GKE Module

Creates a minimal Google Kubernetes Engine cluster with a dedicated node pool.

## Usage

```hcl
module "gke" {
  source = "../../modules/gke"

  project_id  = "my-project"
  name        = "app-cluster"
  location    = "us-central1"
  network     = module.vpc.vpc_name
  subnetwork  = module.vpc.private_subnet_ids["private-a"]
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
