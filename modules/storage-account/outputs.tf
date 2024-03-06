output "id" {
  description = "The resource ID of the Storage Account."
  value       = azurerm_storage_account.storage_account.id
}

output "name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.storage_account.name
}

output "object" {
  description = "The Storage Account object."
  value       = azurerm_storage_account.storage_account
}

output "private_endpoint_id" {
  description = "The resource ID of the Private Endpoint of the Storage Account."
  value       = azurerm_private_endpoint.private_endpoint.id
}

output "private_endpoint_name" {
  description = "The name of the Private Endpoint of the Storage Account."
  value       = azurerm_private_endpoint.private_endpoint.name
}

output "private_endpoint_object" {
  description = "The Private Endpoint object"
  value       = azurerm_private_endpoint.private_endpoint
}
