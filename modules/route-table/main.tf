resource "azurerm_route_table" "route_table" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.route_table_name

  dynamic "route" {
    for_each = var.routes

    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_subnet_route_table_association" "subnet_route_table_associations" {
  for_each = var.associated_subnet_ids

  route_table_id = azurerm_route_table.route_table.id
  subnet_id = each.value
}

