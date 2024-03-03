output "id" {
  value       = azurerm_storage_account.storage_account.id
  description = "the resource id of the storage account"
}

output "name" {
  value       = azurerm_storage_account.storage_account.name
  description = "the name of the storage account"
}

output "endpoint_id" {
  value       = azurerm_private_endpoint.private_endpoint.id
  description = "the resource id of the private endpoint"
}

output "endpoint_name" {
  value       = azurerm_private_endpoint.private_endpoint.name
  description = "the name of the private endpoint"
}

