output "id" {
  description = "The ID of the Route Table."
  value       = azurerm_route_table.route_table.id
}

output "name" {
  description = "The name of the Route Table."
  value       = azurerm_route_table.route_table.name
}

output "object" {
  description = "The Route Table object"
  value       = azurerm_route_table.route_table
}

output "routes" {
  description = "A list of routes present on the Route Table."
  value       = azurerm_route_table.route_table.route
}

output "associated_subnets" {
  description = "A list of Subnets associated with the Route Table."
  value       = azurerm_subnet_route_table_association.subnet_route_table_associations
}
