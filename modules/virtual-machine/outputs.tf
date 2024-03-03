output "id" {
  value       = var.vm_type == "linux" ? azurerm_linux_virtual_machine.virtual_machine[0].id : azurerm_windows_virtual_machine.virtual_machine[0].id
  description = "the ID of the virtual machine"
}

output "name" {
  value       = var.vm_type == "linux" ? azurerm_linux_virtual_machine.virtual_machine[0].name : azurerm_windows_virtual_machine.virtual_machine[0].name
  description = "the name of the virtual machine"
}

output "identities" {
  value       = var.identities_list
  description = "the IDs of the identities connected to this virtual machine."
}

output "admin_username" {
  value = var.vm_type == "linux" ? azurerm_linux_virtual_machine.virtual_machine[0].admin_username : azurerm_windows_virtual_machine.virtual_machine[0].admin_username

  description = "the admin username of the virtual machine."
}

output "admin_password" {
  value     = var.vm_type == "linux" ? azurerm_linux_virtual_machine.virtual_machine[0].admin_password : azurerm_windows_virtual_machine.virtual_machine[0].admin_password
  sensitive = true

  description = "sensitive. the password for the admin user of the virtual machine."
}
