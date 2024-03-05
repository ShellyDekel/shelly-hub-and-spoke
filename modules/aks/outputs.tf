output "id" {
  description = "The id of the AKS."
  value       = azurerm_kubernetes_cluster.azure_kubernetes_service.id
}

output "name" {
  description = "The name of the AKS."
  value       = azurerm_kubernetes_cluster.azure_kubernetes_service.name
}

output "object" {
  description = "The AKS object."
  value       = azurerm_kubernetes_cluster.azure_kubernetes_service
}

output "node_pools" {
  description = "The Node Pools of the AKS."
  value       = azurerm_kubernetes_cluster_node_pool.node_pools
}