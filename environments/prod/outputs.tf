output "environment" {
  description = "Outputs for resources managed in this environment. Only includes resource types configured in terraform.tfvars."
  value = merge(
    length(var.projects) > 0 ? {
      projects = {
        project_ids = { for name, project in module.project_services : name => project.project_id }
        services    = { for name, project in module.project_services : name => project.enabled_services }
      }
    } : {},
    length(var.cloud_storage_buckets) > 0 ? {
      cloud_storage = {
        bucket_names = { for name, bucket in module.cloud_storage : name => bucket.bucket_name }
        bucket_urls  = { for name, bucket in module.cloud_storage : name => bucket.bucket_url }
        bucket_ids   = { for name, bucket in module.cloud_storage : name => bucket.bucket_id }
      }
    } : {},
    length(var.secret_manager_secrets) > 0 ? {
      secret_manager = {
        secret_names = { for name, secret in module.secret_manager : name => secret.secret_name }
        secret_ids   = { for name, secret in module.secret_manager : name => secret.secret_id }
      }
    } : {},
    length(var.kms_keys) > 0 ? {
      kms = {
        crypto_key_names = { for name, key in module.kms : name => key.crypto_key_name }
        key_ring_ids     = { for name, key in module.kms : name => key.key_ring_id }
      }
    } : {},
    length(var.vpcs) > 0 ? {
      vpcs = {
        vpc_names             = { for name, vpc in module.vpc : name => vpc.vpc_name }
        vpc_ids               = { for name, vpc in module.vpc : name => vpc.vpc_id }
        public_subnet_ids     = { for name, vpc in module.vpc : name => vpc.public_subnet_ids }
        private_subnet_ids    = { for name, vpc in module.vpc : name => vpc.private_subnet_ids }
      }
    } : {},
    length(var.firewall_rules) > 0 ? {
      firewall = {
        ingress_rule_ids = { for name, fw in module.firewall : name => fw.ingress_firewall_ids }
        egress_rule_ids  = { for name, fw in module.firewall : name => fw.egress_firewall_ids }
      }
    } : {},
    length(var.load_balancers) > 0 ? {
      load_balancers = {
        forwarding_rule_ips = { for name, lb in module.load_balancer : name => lb.forwarding_rule_ip }
      }
    } : {},
    length(var.https_load_balancers) > 0 ? {
      https_load_balancers = {
        ip_addresses = { for name, lb in module.https_load_balancer : name => lb.global_address }
      }
    } : {},
    length(var.cloud_functions) > 0 ? {
      cloud_functions = {
        names = { for name, fn in module.cloud_functions : name => fn.function_name }
        uris  = { for name, fn in module.cloud_functions : name => fn.function_uri }
      }
    } : {},
    length(var.cloud_cdn_backends) > 0 ? {
      cloud_cdn = {
        backend_bucket_names = { for name, cdn in module.cloud_cdn : name => cdn.backend_bucket_name }
      }
    } : {},
    length(var.artifact_registries) > 0 ? {
      artifact_registries = {
        repository_ids = { for name, repo in module.artifact_registry : name => repo.repository_id }
        registry_urls  = { for name, repo in module.artifact_registry : name => repo.repository_url }
      }
    } : {},
    length(var.iam_service_accounts) > 0 ? {
      iam = {
        service_account_emails = { for name, sa in module.iam : name => sa.service_account_email }
      }
    } : {},
    length(var.compute_instances) > 0 ? {
      compute_instances = {
        names        = { for name, vm in module.compute_instance : name => vm.instance_name }
        internal_ips = { for name, vm in module.compute_instance : name => vm.internal_ip }
        external_ips = { for name, vm in module.compute_instance : name => vm.external_ip }
      }
    } : {},
    length(var.cloud_sql_instances) > 0 ? {
      cloud_sql = {
        instance_names  = { for name, db in module.cloud_sql : name => db.instance_name }
        connection_names = { for name, db in module.cloud_sql : name => db.connection_name }
        private_ips     = { for name, db in module.cloud_sql : name => db.private_ip_address }
      }
    } : {},
    length(var.api_gateways) > 0 ? {
      api_gateways = {
        gateway_urls = { for name, gw in module.api_gateway : name => gw.gateway_default_hostname }
      }
    } : {},
    length(var.pubsub_topics) > 0 ? {
      pubsub_topics = {
        topic_names = { for name, topic in module.pubsub_topic : name => topic.topic_name }
      }
    } : {},
    length(var.pubsub_subscriptions) > 0 ? {
      pubsub_subscriptions = {
        subscription_names = { for name, sub in module.pubsub_subscription : name => sub.subscription_name }
      }
    } : {},
    length(var.gke_clusters) > 0 ? {
      gke = {
        cluster_names = { for name, cluster in module.gke : name => cluster.cluster_name }
        endpoints     = { for name, cluster in module.gke : name => cluster.cluster_endpoint }
      }
    } : {},
    length(var.cloud_run_services) > 0 ? {
      cloud_run = {
        service_names = { for name, svc in module.cloud_run : name => svc.service_name }
        service_uris  = { for name, svc in module.cloud_run : name => svc.service_uri }
      }
    } : {},
    length(var.filestore_instances) > 0 ? {
      filestore = {
        instance_names = { for name, fs in module.filestore : name => fs.instance_name }
        ip_addresses   = { for name, fs in module.filestore : name => fs.ip_addresses }
      }
    } : {},
  )
}

output "cloud_sql_root_passwords" {
  description = "Generated Cloud SQL root passwords keyed by logical name."
  value       = { for name, db in module.cloud_sql : name => db.root_password }
  sensitive   = true
}

output "compute_instance_passwords" {
  description = "Generated VM passwords keyed by logical name."
  value       = { for name, vm in module.compute_instance : name => vm.generated_password }
  sensitive   = true
}
