output "id" {
  description = "The ID of the VM."
  value       = var.type == local.types["linux"] ? azurerm_linux_virtual_machine.virtual_machine[0].id : azurerm_windows_virtual_machine.virtual_machine[0].id
}

output "name" {
  description = "The name of the VM."
  value       = var.type == local.types["linux"] ? azurerm_linux_virtual_machine.virtual_machine[0].name : azurerm_windows_virtual_machine.virtual_machine[0].name
}

output "admin_username" {
  description = "The Admin Username of the VM."
  value = var.type == local.types["linux"] ? azurerm_linux_virtual_machine.virtual_machine[0].admin_username : azurerm_windows_virtual_machine.virtual_machine[0].admin_username
}

output "admin_password" {
  description = "Sensitive. The password for the Admin User of the VM."
  value     = var.type == local.types["linux"] ? azurerm_linux_virtual_machine.virtual_machine[0].admin_password : azurerm_windows_virtual_machine.virtual_machine[0].admin_password
  sensitive = true
}

output "private_ip_address" {
  description = "The private IP Address of the VM."
  value       = var.type == local.types["linux"] ? azurerm_linux_virtual_machine.virtual_machine[0].private_ip_address : azurerm_windows_virtual_machine.virtual_machine[0].private_ip_address
}
