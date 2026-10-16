# Firewall Module

Creates VPC firewall rules for ingress and egress traffic.

## Usage

```hcl
module "firewall" {
  source = "../../modules/firewall"

  project_id = "my-project"
  name       = "app"
  network    = module.vpc.vpc_self_link

  target_tags = ["app-public"]

  ingress_rules = {
    http = {
      allow = [{ protocol = "tcp", ports = ["80", "443"] }]
      source_ranges = ["0.0.0.0/0"]
    }
  }
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
