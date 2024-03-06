output "id" {
  description = "The ID of the Managed Identity"
  value       = azurerm_user_assigned_identity.managed_identity.id
}

output "name" {
  description = "The name of the Managed Identity"
  value       = azurerm_user_assigned_identity.managed_identity.name
}

output "object" {
  description = "The Managed Identity object."
  value       = azurerm_user_assigned_identity.managed_identity
}

output "role_assignments" {
  description = "A list of the Role Assignments associated with thie Managed Identity."
  value       = azurerm_role_assignment.role_assignments
}
