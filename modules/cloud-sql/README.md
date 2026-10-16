# Cloud SQL Module

Creates a PostgreSQL Cloud SQL instance with optional database and generated password.

## Usage

```hcl
module "cloud_sql" {
  source = "../../modules/cloud-sql"

  project_id       = "my-project"
  name             = "app-db"
  region           = "us-central1"
  database_name    = "app"
  generate_password = { length = 20 }
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
