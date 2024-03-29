resource "azurerm_user_assigned_identity" "managed_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.name

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  role_assignments = toset(var.role_assignments)
}

resource "azurerm_role_assignment" "role_assignments" {
  for_each = local.role_assignments

  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
  role_definition_name = each.key
  scope                = each.value
}
