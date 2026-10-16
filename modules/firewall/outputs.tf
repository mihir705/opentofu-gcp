output "ingress_firewall_ids" {
  description = "Ingress firewall rule IDs keyed by rule name."
  value       = { for key, rule in google_compute_firewall.ingress : key => rule.id }
}

output "egress_firewall_ids" {
  description = "Egress firewall rule IDs keyed by rule name."
  value       = { for key, rule in google_compute_firewall.egress : key => rule.id }
}

output "ingress_firewall_self_links" {
  description = "Ingress firewall rule self links keyed by rule name."
  value       = { for key, rule in google_compute_firewall.ingress : key => rule.self_link }
}

output "egress_firewall_self_links" {
  description = "Egress firewall rule self links keyed by rule name."
  value       = { for key, rule in google_compute_firewall.egress : key => rule.self_link }
}
