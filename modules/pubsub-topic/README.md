# Pub/Sub Topic Module

Creates a Google Cloud Pub/Sub topic.

## Usage

```hcl
module "pubsub_topic" {
  source = "../../modules/pubsub-topic"

  project_id = "my-project"
  name       = "app-events"
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
