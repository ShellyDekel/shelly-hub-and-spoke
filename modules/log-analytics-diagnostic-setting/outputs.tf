output "id" {
  description = "The ID of the Diagnostic Setting."
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.id
}

output "name" {
  description = "The name of the Diagnostic Setting."
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.name
}

output "object" {
  description = "The Diagnostic Setting object"
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting
}
