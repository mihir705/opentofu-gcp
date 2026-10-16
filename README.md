# opentofu-gcp

Reusable OpenTofu modules for Google Cloud Storage, Secret Manager, Cloud KMS, Cloud Functions, Cloud CDN, VPC, Load Balancer, HTTPS Load Balancer, Firewall rules, Artifact Registry, IAM service accounts, Compute Engine, Cloud SQL (PostgreSQL), API Gateway, Pub/Sub, GKE, Cloud Run, and Filestore — deployed per environment.

This repository is the OpenTofu counterpart of `terraform-gcp`. HCL is the same; use the `tofu` CLI and the OpenTofu registry for providers.

## Structure

```
opentofu-gcp/
├── modules/
│   ├── project-services/
│   ├── cloud-storage/
│   ├── secret-manager/
│   ├── kms/
│   ├── cloud-functions/
│   ├── cloud-cdn/
│   ├── vpc/
│   ├── load-balancer/
│   ├── https-load-balancer/
│   ├── firewall/
│   ├── artifact-registry/
│   ├── iam/
│   ├── compute-instance/
│   ├── cloud-sql/
│   ├── api-gateway/
│   ├── pubsub-topic/
│   ├── pubsub-subscription/
│   ├── gke/
│   ├── cloud-run/
│   └── filestore/
└── environments/
    └── prod/
        ├── backend.tf
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── versions.tf
        └── terraform.tfvars.example
```

Add more environments by copying `environments/prod` to `environments/dev`, `environments/staging`, etc.

## Modules

| Module | Purpose |
|--------|---------|
| `project-services` | Enable Google Cloud APIs on a project |
| `cloud-storage` | GCS buckets with versioning, lifecycle, CORS, optional KMS encryption |
| `secret-manager` | Secret Manager secrets with optional generated values |
| `kms` | Cloud KMS key rings and crypto keys |
| `cloud-functions` | Cloud Functions (2nd gen) |
| `cloud-cdn` | CDN-enabled backend buckets |
| `vpc` | VPC networks, subnets, Cloud NAT, default firewall rules |
| `load-balancer` | Regional external TCP/UDP network load balancer |
| `https-load-balancer` | Global HTTPS load balancer with managed certificates |
| `firewall` | VPC firewall rules (ingress/egress) |
| `artifact-registry` | Artifact Registry repositories |
| `iam` | Service accounts and project IAM role bindings |
| `compute-instance` | Compute Engine VMs |
| `cloud-sql` | Cloud SQL for PostgreSQL |
| `api-gateway` | API Gateway API, config, and gateway |
| `pubsub-topic` | Pub/Sub topics |
| `pubsub-subscription` | Pub/Sub subscriptions |
| `gke` | GKE clusters and node pools |
| `cloud-run` | Cloud Run services |
| `filestore` | Filestore NFS instances |

## How it works

Each **environment** (e.g. `prod`) manages all resources for that environment in one place:

| `terraform.tfvars` block | Module |
|--------------------------|--------|
| `projects` | Project Services (API enablement) |
| `cloud_storage_buckets` | Cloud Storage |
| `secret_manager_secrets` | Secret Manager |
| `kms_keys` | Cloud KMS |
| `cloud_functions` | Cloud Functions (2nd gen) |
| `cloud_cdn_backends` | Cloud CDN |
| `vpcs` | VPC |
| `load_balancers` | Regional Load Balancer (L4) |
| `https_load_balancers` | HTTPS Load Balancer (L7) |
| `firewall_rules` | VPC Firewall |
| `artifact_registries` | Artifact Registry |
| `iam_service_accounts` | IAM Service Account |
| `compute_instances` | Compute Engine |
| `cloud_sql_instances` | Cloud SQL PostgreSQL |
| `api_gateways` | API Gateway |
| `pubsub_topics` | Pub/Sub Topic |
| `pubsub_subscriptions` | Pub/Sub Subscription |
| `gke_clusters` | GKE |
| `cloud_run_services` | Cloud Run |
| `filestore_instances` | Filestore |

Each module includes a **`terraform.tfvars.example`** alongside its README with focused configuration examples. Copy the blocks you need into `environments/prod/terraform.tfvars`.

Modules are independent. Omit any block from `terraform.tfvars` when you are not managing that resource type. No empty `{}` required.

Outputs are grouped under `environment` and only include resource types you configure.

## Prerequisites

- **OpenTofu** >= 1.6.0 (`tofu` CLI)
- **GCS bucket** for remote state (create manually or with a bootstrap stack)
- **GCP project** with billing enabled
- Authenticate with Application Default Credentials (`gcloud auth application-default login`) or a service account key before running OpenTofu

| Environment | State prefix |
|-------------|--------------|
| prod | `opentofu-gcp/prod` |

Environment providers:

- `google` — primary provider
- `google-beta` — API Gateway and other beta resources
- `random` — generated passwords for secrets and databases
- `archive` — Cloud Functions package zip builds

## Quick start (prod)

```bash
cd environments/prod
cp terraform.tfvars.example terraform.tfvars
# edit backend.tf and terraform.tfvars
tofu init
tofu plan
tofu apply
```

```bash
tofu output environment
```

## Secret Manager dependency order

Secrets are standalone in Secret Manager. Reference them from Cloud Run, Cloud Functions, or GKE via IAM:

```hcl
secret_manager_secrets = {
  app-config = {
    secret_id = "app-config"
    generate_random_password = {
      length = 32
    }
  }
}
```

## Cloud Functions deployment packages

Zip-based Cloud Functions load code from Cloud Storage. Create a bucket first, then reference it:

```hcl
cloud_storage_buckets = {
  function-artifacts = {
    name = "mycompany-function-artifacts-prod"
  }
}

cloud_functions = {
  api-handler = {
    name              = "api-handler-prod"
    runtime           = "python312"
    entry_point       = "hello_http"
    source_dir        = "function-src/api-handler"
    source_bucket_key = "function-artifacts"
  }
}
```

## Module documentation

Each module under `modules/` has a README and `terraform.tfvars.example`:

- [modules/project-services/README.md](modules/project-services/README.md)
- [modules/cloud-storage/README.md](modules/cloud-storage/README.md)
- [modules/secret-manager/README.md](modules/secret-manager/README.md)
- [modules/kms/README.md](modules/kms/README.md)
- [modules/cloud-functions/README.md](modules/cloud-functions/README.md)
- [modules/cloud-cdn/README.md](modules/cloud-cdn/README.md)
- [modules/vpc/README.md](modules/vpc/README.md)
- [modules/load-balancer/README.md](modules/load-balancer/README.md)
- [modules/https-load-balancer/README.md](modules/https-load-balancer/README.md)
- [modules/firewall/README.md](modules/firewall/README.md)
- [modules/artifact-registry/README.md](modules/artifact-registry/README.md)
- [modules/iam/README.md](modules/iam/README.md)
- [modules/compute-instance/README.md](modules/compute-instance/README.md)
- [modules/cloud-sql/README.md](modules/cloud-sql/README.md)
- [modules/api-gateway/README.md](modules/api-gateway/README.md)
- [modules/pubsub-topic/README.md](modules/pubsub-topic/README.md)
- [modules/pubsub-subscription/README.md](modules/pubsub-subscription/README.md)
- [modules/gke/README.md](modules/gke/README.md)
- [modules/cloud-run/README.md](modules/cloud-run/README.md)
- [modules/filestore/README.md](modules/filestore/README.md)

Never commit real secret values to version control.
