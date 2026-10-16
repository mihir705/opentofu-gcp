locals {
  project_ids = {
    for key, project in var.projects : key => project.project_id
  }

  resolve_project_id = {
    for key, cfg in merge(
      { for k, v in var.cloud_storage_buckets : "cloud_storage_buckets:${k}" => v },
      { for k, v in var.secret_manager_secrets : "secret_manager_secrets:${k}" => v },
      { for k, v in var.kms_keys : "kms_keys:${k}" => v },
      { for k, v in var.vpcs : "vpcs:${k}" => v },
      { for k, v in var.firewall_rules : "firewall_rules:${k}" => v },
      { for k, v in var.load_balancers : "load_balancers:${k}" => v },
      { for k, v in var.https_load_balancers : "https_load_balancers:${k}" => v },
      { for k, v in var.cloud_functions : "cloud_functions:${k}" => v },
      { for k, v in var.cloud_cdn_backends : "cloud_cdn_backends:${k}" => v },
      { for k, v in var.artifact_registries : "artifact_registries:${k}" => v },
      { for k, v in var.iam_service_accounts : "iam_service_accounts:${k}" => v },
      { for k, v in var.compute_instances : "compute_instances:${k}" => v },
      { for k, v in var.cloud_sql_instances : "cloud_sql_instances:${k}" => v },
      { for k, v in var.api_gateways : "api_gateways:${k}" => v },
      { for k, v in var.pubsub_topics : "pubsub_topics:${k}" => v },
      { for k, v in var.pubsub_subscriptions : "pubsub_subscriptions:${k}" => v },
      { for k, v in var.gke_clusters : "gke_clusters:${k}" => v },
      { for k, v in var.cloud_run_services : "cloud_run_services:${k}" => v },
      { for k, v in var.filestore_instances : "filestore_instances:${k}" => v },
    ) : key => coalesce(
      try(cfg.project_id, null),
      try(local.project_ids[cfg.project_key], null),
      var.gcp_project_id
    )
  }

  resolve_region = {
    for key, cfg in merge(
      { for k, v in var.cloud_storage_buckets : "cloud_storage_buckets:${k}" => v },
      { for k, v in var.vpcs : "vpcs:${k}" => v },
      { for k, v in var.load_balancers : "load_balancers:${k}" => v },
      { for k, v in var.https_load_balancers : "https_load_balancers:${k}" => v },
      { for k, v in var.cloud_functions : "cloud_functions:${k}" => v },
      { for k, v in var.artifact_registries : "artifact_registries:${k}" => v },
      { for k, v in var.compute_instances : "compute_instances:${k}" => v },
      { for k, v in var.cloud_sql_instances : "cloud_sql_instances:${k}" => v },
      { for k, v in var.api_gateways : "api_gateways:${k}" => v },
      { for k, v in var.gke_clusters : "gke_clusters:${k}" => v },
      { for k, v in var.cloud_run_services : "cloud_run_services:${k}" => v },
      { for k, v in var.filestore_instances : "filestore_instances:${k}" => v },
    ) : key => coalesce(try(cfg.region, null), var.gcp_region)
  }

  load_balancer_subnet_self_links = {
    for name, lb in var.load_balancers : name => coalesce(
      try(lb.subnet_self_link, null),
      try(module.vpc[lb.vpc_key].public_subnet_self_links[lb.subnet_key], null)
    )
  }

  compute_instance_subnet_self_links = {
    for name, vm in var.compute_instances : name => coalesce(
      try(vm.subnet_self_link, null),
      try(vm.subnet_tier, "private") == "public" ?
      module.vpc[vm.vpc_key].public_subnet_self_links[vm.subnet_key] :
      module.vpc[vm.vpc_key].private_subnet_self_links[vm.subnet_key]
    )
  }

  gke_subnetwork_self_links = {
    for name, cluster in var.gke_clusters : name => coalesce(
      try(cluster.subnetwork_self_link, null),
      try(module.vpc[cluster.vpc_key].private_subnet_self_links[cluster.subnet_key], null)
    )
  }
}

module "project_services" {
  source = "../../modules/project-services"

  for_each = var.projects

  project_id = each.value.project_id
  services   = try(each.value.services, [])
}

resource "time_sleep" "wait_for_apis" {
  depends_on = [module.project_services]

  create_duration = "90s"
}

module "cloud_storage" {
  source = "../../modules/cloud-storage"

  for_each = var.cloud_storage_buckets

  project_id                  = local.resolve_project_id["cloud_storage_buckets:${each.key}"]
  name                        = each.value.name
  location                    = try(each.value.location, "US")
  storage_class               = try(each.value.storage_class, "STANDARD")
  force_destroy               = try(each.value.force_destroy, false)
  uniform_bucket_level_access = try(each.value.uniform_bucket_level_access, true)
  public_access_prevention    = try(each.value.public_access_prevention, "enforced")
  versioning_enabled          = try(each.value.versioning_enabled, false)
  lifecycle_rules             = try(each.value.lifecycle_rules, [])
  cors                        = try(each.value.cors, [])
  encryption_kms_key_name     = try(each.value.encryption_kms_key_name, null)
  labels                      = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis]
}

module "secret_manager" {
  source = "../../modules/secret-manager"

  for_each = var.secret_manager_secrets

  project_id               = local.resolve_project_id["secret_manager_secrets:${each.key}"]
  secret_id                = each.value.secret_id
  secret_value             = try(each.value.secret_value, null)
  generate_random_password = try(each.value.generate_random_password, null)
  replication_locations    = try(each.value.replication_locations, [])
  labels                   = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis]
}

module "kms" {
  source = "../../modules/kms"

  for_each = var.kms_keys

  project_id      = local.resolve_project_id["kms_keys:${each.key}"]
  location        = each.value.location
  key_ring_name   = each.value.key_ring_name
  crypto_key_name = each.value.crypto_key_name
  purpose         = try(each.value.purpose, "ENCRYPT_DECRYPT")
  rotation_period = try(each.value.rotation_period, "7776000s")
  labels          = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis]
}

module "vpc" {
  source = "../../modules/vpc"

  for_each = var.vpcs

  project_id                    = local.resolve_project_id["vpcs:${each.key}"]
  name                          = each.value.name
  region                        = local.resolve_region["vpcs:${each.key}"]
  routing_mode                  = try(each.value.routing_mode, "REGIONAL")
  public_subnets                = each.value.public_subnets
  private_subnets               = each.value.private_subnets
  enable_cloud_nat              = try(each.value.enable_cloud_nat, true)
  nat_ip_allocate_option        = try(each.value.nat_ip_allocate_option, "AUTO_ONLY")
  create_public_firewall        = try(each.value.create_public_firewall, true)
  create_private_firewall       = try(each.value.create_private_firewall, true)
  public_firewall_source_ranges = try(each.value.public_firewall_source_ranges, ["0.0.0.0/0"])
  labels                        = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis]
}

module "firewall" {
  source = "../../modules/firewall"

  for_each = var.firewall_rules

  project_id    = local.resolve_project_id["firewall_rules:${each.key}"]
  name          = each.value.name
  network       = coalesce(try(each.value.network, null), try(module.vpc[each.value.vpc_key].vpc_self_link, null))
  description   = try(each.value.description, null)
  direction     = try(each.value.direction, "INGRESS")
  priority      = try(each.value.priority, 1000)
  ingress_rules = try(each.value.ingress_rules, {})
  egress_rules  = try(each.value.egress_rules, {})
  target_tags   = try(each.value.target_tags, [])
  labels        = merge(var.default_labels, try(each.value.labels, {}))
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  for_each = var.load_balancers

  project_id                = local.resolve_project_id["load_balancers:${each.key}"]
  name                      = each.value.name
  region                    = local.resolve_region["load_balancers:${each.key}"]
  network                   = module.vpc[each.value.vpc_key].vpc_self_link
  subnet                    = local.load_balancer_subnet_self_links[each.key]
  protocol                  = try(each.value.protocol, "TCP")
  port                      = try(each.value.port, 80)
  backend_instance_groups   = try(each.value.backend_instance_groups, [])
  backend_instances = concat(
    try(each.value.backend_instances, []),
    [for k in try(each.value.compute_instance_keys, []) : module.compute_instance[k].instance_self_link]
  )
  health_check_port         = try(each.value.health_check_port, null)
  labels                    = merge(var.default_labels, try(each.value.labels, {}))
}

module "https_load_balancer" {
  source = "../../modules/https-load-balancer"

  for_each = var.https_load_balancers

  project_id                = local.resolve_project_id["https_load_balancers:${each.key}"]
  name                      = each.value.name
  region                    = local.resolve_region["https_load_balancers:${each.key}"]
  domains                   = each.value.domains
  backend_port              = try(each.value.backend_port, 80)
  backend_instance_groups = try(each.value.backend_instance_groups, [])
  backend_instances = concat(
    try(each.value.backend_instances, []),
    [for k in try(each.value.compute_instance_keys, []) : module.compute_instance[k].instance_self_link]
  )
  backend_bucket = coalesce(
    try(each.value.backend_bucket, null),
    try(module.cloud_cdn[each.value.cloud_cdn_backend_key].backend_bucket_id, null)
  )
  backend_service           = try(each.value.backend_service, {})
  labels                    = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [module.cloud_cdn, module.compute_instance]
}

module "cloud_functions" {
  source = "../../modules/cloud-functions"

  for_each = var.cloud_functions

  project_id            = local.resolve_project_id["cloud_functions:${each.key}"]
  name                  = each.value.name
  location              = local.resolve_region["cloud_functions:${each.key}"]
  runtime               = each.value.runtime
  entry_point           = each.value.entry_point
  source_dir            = try(each.value.source_dir, null)
  source_bucket         = coalesce(try(each.value.source_bucket, null), try(module.cloud_storage[each.value.source_bucket_key].bucket_name, null))
  source_object         = try(each.value.source_object, null)
  service_account_email = coalesce(
    try(each.value.service_account_email, null),
    try(module.iam[each.value.service_account_key].service_account_email, null)
  )
  labels = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis, module.cloud_storage]
}

module "cloud_cdn" {
  source = "../../modules/cloud-cdn"

  for_each = var.cloud_cdn_backends

  project_id  = local.resolve_project_id["cloud_cdn_backends:${each.key}"]
  name        = each.value.name
  bucket_name = coalesce(
    try(each.value.bucket_name, null),
    try(module.cloud_storage[each.value.bucket_key].bucket_name, null)
  )
  labels = merge(var.default_labels, try(each.value.labels, {}))
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"

  for_each = var.artifact_registries

  project_id     = local.resolve_project_id["artifact_registries:${each.key}"]
  location     = local.resolve_region["artifact_registries:${each.key}"]
  repository_id = each.value.repository_id
  format       = try(each.value.format, "DOCKER")
  labels       = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis]
}

module "iam" {
  source = "../../modules/iam"

  for_each = var.iam_service_accounts

  project_id    = local.resolve_project_id["iam_service_accounts:${each.key}"]
  account_id   = each.value.account_id
  display_name = try(each.value.display_name, null)
  roles        = try(each.value.roles, [])
}

module "compute_instance" {
  source = "../../modules/compute-instance"

  for_each = var.compute_instances

  project_id              = local.resolve_project_id["compute_instances:${each.key}"]
  name                    = each.value.name
  zone                    = each.value.zone
  machine_type            = each.value.machine_type
  subnet_self_link        = local.compute_instance_subnet_self_links[each.key]
  network_tags            = try(each.value.network_tags, [])
  boot_disk               = try(each.value.boot_disk, null)
  metadata                = try(each.value.metadata, {})
  service_account_email   = coalesce(
    try(each.value.service_account_email, null),
    try(module.iam[each.value.service_account_key].service_account_email, null)
  )
  create_public_ip        = try(each.value.create_public_ip, false)
  generate_password       = try(each.value.generate_password, null)
  labels                  = merge(var.default_labels, try(each.value.labels, {}))
}

module "cloud_sql" {
  source = "../../modules/cloud-sql"

  for_each = var.cloud_sql_instances

  project_id        = local.resolve_project_id["cloud_sql_instances:${each.key}"]
  name              = each.value.name
  region            = local.resolve_region["cloud_sql_instances:${each.key}"]
  tier              = try(each.value.tier, "db-f1-micro")
  database_version  = try(each.value.database_version, "POSTGRES_15")
  disk_size         = try(each.value.disk_size, 10)
  private_network = try(each.value.private_network, null) != null ? each.value.private_network : (
    try(each.value.vpc_key, null) != null ? module.vpc[each.value.vpc_key].vpc_self_link : null
  )
  database_name     = try(each.value.database_name, null)
  generate_password = try(each.value.generate_password, null)
  root_password     = try(each.value.root_password, null)
  deletion_protection = try(each.value.deletion_protection, false)
  labels            = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis]
}

module "api_gateway" {
  source = "../../modules/api-gateway"

  for_each = var.api_gateways

  project_id   = local.resolve_project_id["api_gateways:${each.key}"]
  api_id       = each.value.api_id
  gateway_id   = each.value.gateway_id
  region          = local.resolve_region["api_gateways:${each.key}"]
  openapi_spec    = try(each.value.openapi_spec, null)
  backend_address = coalesce(
    try(each.value.backend_address, null),
    try(module.cloud_run[each.value.cloud_run_service_key].service_uri, null)
  )
  labels = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis, module.cloud_run]
}

module "pubsub_topic" {
  source = "../../modules/pubsub-topic"

  for_each = var.pubsub_topics

  project_id                 = local.resolve_project_id["pubsub_topics:${each.key}"]
  name                       = each.value.name
  message_retention_duration = try(each.value.message_retention_duration, null)
  labels                     = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis]
}

module "pubsub_subscription" {
  source = "../../modules/pubsub-subscription"

  for_each = var.pubsub_subscriptions

  project_id           = local.resolve_project_id["pubsub_subscriptions:${each.key}"]
  name                 = each.value.name
  topic_id             = coalesce(
    try(each.value.topic_id, null),
    try(module.pubsub_topic[each.value.topic_key].topic_id, null)
  )
  topic_name = coalesce(
    try(each.value.topic_name, null),
    try(each.value.topic_key, null) != null ? try(module.pubsub_topic[each.value.topic_key].topic_name, null) : null
  )
  ack_deadline_seconds = try(each.value.ack_deadline_seconds, 20)
  labels               = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [module.pubsub_topic]
}

module "gke" {
  source = "../../modules/gke"

  for_each = var.gke_clusters

  project_id         = local.resolve_project_id["gke_clusters:${each.key}"]
  name               = each.value.name
  location           = try(each.value.location, local.resolve_region["gke_clusters:${each.key}"])
  region             = local.resolve_region["gke_clusters:${each.key}"]
  network            = module.vpc[each.value.vpc_key].vpc_name
  subnetwork         = local.gke_subnetwork_self_links[each.key]
  initial_node_count = try(each.value.initial_node_count, 1)
  node_pool          = try(each.value.node_pool, {})
  deletion_protection = try(each.value.deletion_protection, false)
  labels             = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis, module.vpc]
}

module "cloud_run" {
  source = "../../modules/cloud-run"

  for_each = var.cloud_run_services

  project_id     = local.resolve_project_id["cloud_run_services:${each.key}"]
  name           = each.value.name
  location       = local.resolve_region["cloud_run_services:${each.key}"]
  image          = each.value.image
  env            = try(each.value.env, {})
  ingress           = try(each.value.ingress, "INGRESS_TRAFFIC_ALL")
  vpc_connector     = try(each.value.vpc_connector, null)
  deletion_protection = try(each.value.deletion_protection, false)
  labels            = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis]
}

module "filestore" {
  source = "../../modules/filestore"

  for_each = var.filestore_instances

  project_id        = local.resolve_project_id["filestore_instances:${each.key}"]
  name              = each.value.name
  location          = coalesce(try(each.value.location, null), local.resolve_region["filestore_instances:${each.key}"])
  tier              = try(each.value.tier, "STANDARD")
  capacity_gb       = try(each.value.capacity_gb, 1024)
  network           = coalesce(try(each.value.network, null), try(module.vpc[each.value.vpc_key].vpc_name, null))
  reserved_ip_range = each.value.reserved_ip_range
  labels            = merge(var.default_labels, try(each.value.labels, {}))

  depends_on = [time_sleep.wait_for_apis, module.vpc]
}
