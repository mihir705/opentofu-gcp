# IAM Module

Creates a service account and grants project IAM roles.

## Usage

```hcl
module "iam" {
  source = "../../modules/iam"

  project_id   = "my-project"
  account_id   = "app-runner"
  display_name = "Application Runner"
  roles        = ["roles/logging.logWriter"]
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
