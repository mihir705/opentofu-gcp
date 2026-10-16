terraform {
  backend "gcs" {
    bucket = "tfstate-kubernetes-hardway-439211"
    prefix = "opentofu-gcp/prod"
  }
}
