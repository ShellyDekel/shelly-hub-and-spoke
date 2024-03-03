output "aks_id" {
  value       = azurerm_kubernetes_cluster.azure_kubernetes_service.id
  description = "the id of the aks"
}

output "aks_name" {
  value       = azurerm_kubernetes_cluster.azure_kubernetes_service.name
  description = "the name of the aks"
}

#TODO minimum: id, name, object