output "name" {
  value       = azurerm_route_table.route_table.name
  description = "the name of the route table"
}

output "id" {
  value       = azurerm_route_table.route_table.id
  description = "the id of the route table"
}

output "routes" {
  value       = azurerm_route_table.route_table.route
  description = "a set of routes present on the route table"
}
