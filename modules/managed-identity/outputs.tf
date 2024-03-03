output "managed_identity" {
  value = azurerm_user_assigned_identity.managed_identity

  description = "the managed identity"
}

output "role_assignments" {
  value = values(azurerm_role_assignment.role_assignments)[*].role_definition_name

  description = "a list of the roles assigned to this identity"
}
