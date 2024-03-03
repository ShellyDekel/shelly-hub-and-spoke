output "id" {
  description = "The id of the acr."
  value       = azurerm_container_registry.container_registry.id
}

output "name" {
  description = "The name of the acr."
  value       = azurerm_container_registry.container_registry.name
}

output "object" {
  description = "The acr object."
  value       = azurerm_container_registry.container_registry
}

output "admin_username" {
  value       = azurerm_container_registry.container_registry.admin_username
  description = "The acr admin username."
}

output "admin_password" {
  description = "The acr admin password."
  value       = azurerm_container_registry.container_registry.admin_password
  sensitive   = true
}

output "private_endpoint_id" {
  description = "The id of the private endpoint."
  value       = azurerm_private_endpoint.acr_private_endpoint.id
}

output "private_endpoint_name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.acr_private_endpoint.name
}

output "private_endpoint" {
  description = "The private endpoint object."
  value       = azurerm_private_endpoint.acr_private_endpoint
}

output "private_dns_zone_id" {
  description = "The id of the private dns zone."
  value       = azurerm_private_dns_zone.acr_private_dns_zone.id
}

output "private_dns_zone" {
  description = "The private dns zone object."
  value       = azurerm_private_dns_zone.acr_private_dns_zone
}
