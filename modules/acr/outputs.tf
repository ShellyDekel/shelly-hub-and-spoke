output "acr_id" {
  description = "string, the id of the acr"
  value       = azurerm_container_registry.container_registry.id
}

output "acr_object" {
  description = "string, the id of the acr"
  value       = azurerm_container_registry.container_registry
}

output "acr_name" {
  value       = azurerm_container_registry.container_registry.name
  description = "string, the name of the acr"
}

output "acr_login_server" {
  value       = azurerm_container_registry.container_registry.login_server
  description = "string, the login server of the acr"
}

output "acr_admin_username" {
  value       = azurerm_container_registry.container_registry.admin_username
  description = "string, the acr admin username"
}

output "acr_admin_password" {
  value       = azurerm_container_registry.container_registry.admin_password
  sensitive   = true
  description = "string, sensitive, the acr admin password"
}

output "private_endpoint_id" {
  value       = azurerm_private_endpoint.acr_private_endpoint.id
  description = "string, the id of the private endpoint"
}

output "private_endpoint_name" {
  value       = azurerm_private_endpoint.acr_private_endpoint.name
  description = "tring, he name of the private endpoint"
}
