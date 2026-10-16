# Load Balancer Module

Creates a regional external TCP/UDP network load balancer with health check and forwarding rule. Backends use `balancing_mode = CONNECTION` as required for network load balancers. External forwarding rules do not set `network` or `subnetwork`.

## Usage

```hcl
module "load_balancer" {
  source = "../../modules/load-balancer"

  project_id        = "my-project"
  name              = "app-lb"
  region            = "us-central1"
  backend_instances = [module.compute_instance.instance_self_link]
  port              = 80
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
