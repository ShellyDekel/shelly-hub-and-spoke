output "id" {
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.id
  description = "the id of the diagnostic setting"
}

output "name" {
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.name
  description = "the name of the diagnostic setting"
}
