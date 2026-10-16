output "api_id" {
  description = "API Gateway API ID."
  value       = google_api_gateway_api.api.api_id
}

output "api_config_id" {
  description = "API Gateway config ID."
  value       = google_api_gateway_api_config.config.api_config_id
}

output "gateway_id" {
  description = "API Gateway gateway ID."
  value       = google_api_gateway_gateway.gateway.gateway_id
}

output "gateway_default_hostname" {
  description = "Default hostname for the gateway."
  value       = google_api_gateway_gateway.gateway.default_hostname
}
