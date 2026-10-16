# Pub/Sub Subscription Module

Creates a Google Cloud Pub/Sub subscription linked to a topic.

## Usage

```hcl
module "pubsub_subscription" {
  source = "../../modules/pubsub-subscription"

  project_id = "my-project"
  name       = "app-events-sub"
  topic_name = module.pubsub_topic.topic_name
}
```

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.
