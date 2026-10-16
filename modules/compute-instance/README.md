# Compute Instance Module

Creates a Google Compute Engine VM with optional external IP and generated credentials.

## Usage

```hcl
module "compute_instance" {
  source = "../../modules/compute-instance"

  project_id         = "my-project"
  name               = "app-vm-1"
  zone               = "us-central1-a"
  subnet_self_link   = module.vpc.public_subnet_self_links["public-a"]
  create_public_ip   = true
  network_tags       = ["app-public"]
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
