# Project Services Module

Enables Google Cloud APIs on a project before other modules create resources.

## Example

```hcl
projects = {
  app = {
    project_id = "my-gcp-project-id"
    services = [
      "compute.googleapis.com",
      "storage.googleapis.com",
    ]
  }
}
```
