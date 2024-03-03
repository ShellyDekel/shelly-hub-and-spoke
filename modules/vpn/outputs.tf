output "id" {
  value       = azurerm_virtual_network_gateway.vpn_gateway.id
  description = "the id of the vpn"
}

output "name" {
  value       = azurerm_virtual_network_gateway.vpn_gateway.name
  description = "the name of the vpn"
}
