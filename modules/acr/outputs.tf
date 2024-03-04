output "id" {
  description = "The ID of the ACR."
  value       = azurerm_container_registry.container_registry.id
}

output "name" {
  description = "The name of the ACR."
  value       = azurerm_container_registry.container_registry.name
}

output "object" {
  description = "The ACR object."
  value       = azurerm_container_registry.container_registry
}

output "admin_username" {
  value       = azurerm_container_registry.container_registry.admin_username
  description = "The ACR Admin Username."
}

output "admin_password" {
  description = "The ACR Admin Password."
  value       = azurerm_container_registry.container_registry.admin_password
  sensitive   = true
}

output "private_endpoint_id" {
  description = "The ID of the Private Endpoint."
  value       = azurerm_private_endpoint.ACR_private_endpoint.id
}

output "private_endpoint_name" {
  description = "The name of the Private Endpoint."
  value       = azurerm_private_endpoint.ACR_private_endpoint.name
}

output "private_endpoint" {
  description = "The Private Endpoint object."
  value       = azurerm_private_endpoint.ACR_private_endpoint
}

output "private_dns_zone_id" {
  description = "The ID of the Private DNS Zone."
  value       = azurerm_private_dns_zone.ACR_private_dns_zone.id
}

output "private_dns_zone" {
  description = "The Private DNS Zone object."
  value       = azurerm_private_dns_zone.ACR_private_dns_zone
}
