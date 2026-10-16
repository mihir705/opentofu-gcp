resource "google_compute_firewall" "ingress" {
  for_each = var.ingress_rules

  project     = var.project_id
  name        = "${var.name}-${each.key}"
  network     = var.network
  description = try(each.value.description, var.description)
  direction   = "INGRESS"
  priority    = try(each.value.priority, var.priority)
  target_tags = var.target_tags

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = try(allow.value.ports, null)
    }
  }

  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = try(deny.value.ports, null)
    }
  }

  source_ranges = try(each.value.source_ranges, null)
  source_tags   = try(each.value.source_tags, null)
}

resource "google_compute_firewall" "egress" {
  for_each = var.egress_rules

  project     = var.project_id
  name        = "${var.name}-${each.key}"
  network     = var.network
  description = try(each.value.description, var.description)
  direction   = "EGRESS"
  priority    = try(each.value.priority, var.priority)
  target_tags = var.target_tags

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = try(allow.value.ports, null)
    }
  }

  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = try(deny.value.ports, null)
    }
  }

  destination_ranges = try(each.value.destination_ranges, null)
}
