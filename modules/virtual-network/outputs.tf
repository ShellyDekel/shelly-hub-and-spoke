output "id" {
  value       = azurerm_virtual_network.virtual_network.id
  description = "the id of the virtual network"
}

output "name" {
  value       = azurerm_virtual_network.virtual_network.name
  description = "the name of the virtual network"
}

output "subnets" {
  value       = azurerm_subnet.subnets
  description = "a list of subnets belonging to the virtual network"
}

output "network_peerings" {
  value       = azurerm_virtual_network_peering.network_peerings
  description = "a list of network peerings to the vnet"
}
