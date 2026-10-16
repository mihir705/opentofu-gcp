locals {
  name_prefix = var.name

  all_subnet_keys = sort(concat(keys(var.public_subnets), keys(var.private_subnets)))

  private_subnet_regions = distinct([for subnet in var.private_subnets : subnet.region])

  common_labels = merge(var.labels, {
    network = local.name_prefix
  })
}

check "public_subnets_required" {
  assert {
    condition     = length(var.public_subnets) >= 1
    error_message = "At least one public subnet is required."
  }
}

check "private_subnets_required" {
  assert {
    condition     = length(var.private_subnets) >= 1
    error_message = "At least one private subnet is required."
  }
}

check "nat_requires_private_subnet" {
  assert {
    condition     = !var.enable_cloud_nat || length(var.private_subnets) > 0
    error_message = "enable_cloud_nat requires at least one private subnet."
  }
}

resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = local.name_prefix
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

resource "google_compute_subnetwork" "public" {
  for_each = var.public_subnets

  project       = var.project_id
  name          = "${local.name_prefix}-public-${each.key}"
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private" {
  for_each = var.private_subnets

  project       = var.project_id
  name          = "${local.name_prefix}-private-${each.key}"
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true
}

resource "google_compute_router" "nat" {
  for_each = var.enable_cloud_nat ? toset(local.private_subnet_regions) : toset([])

  project = var.project_id
  name    = "${local.name_prefix}-router-${each.key}"
  region  = each.key
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  for_each = var.enable_cloud_nat ? toset(local.private_subnet_regions) : toset([])

  project                            = var.project_id
  name                               = "${local.name_prefix}-nat-${each.key}"
  router                             = google_compute_router.nat[each.key].name
  region                             = each.key
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat   = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = {
      for key, subnet in var.private_subnets : key => subnet
      if subnet.region == each.key
    }
    content {
      name                    = google_compute_subnetwork.private[subnetwork.key].id
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}

resource "google_compute_firewall" "public" {
  count = var.create_public_firewall ? 1 : 0

  project = var.project_id
  name    = "${local.name_prefix}-public-allow-http-https"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = var.public_firewall_source_ranges
  target_tags   = ["${local.name_prefix}-public"]
}

resource "google_compute_firewall" "private" {
  count = var.create_private_firewall ? 1 : 0

  project = var.project_id
  name    = "${local.name_prefix}-private-allow-internal"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [for subnet in concat(values(var.public_subnets), values(var.private_subnets)) : subnet.ip_cidr_range]
  target_tags   = ["${local.name_prefix}-private"]
}
