output "id" {
  description = "The ID of the Firewall."
  value       = azurerm_firewall.firewall.id
}

output "name" {
  description = "The name of the Firewall."
  value       = azurerm_firewall.firewall.name
}

output "private_ip_address" {
  description = "The private IP address of the Firewall."
  value       = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

output "object" {
  description = "The Firewall object."
  value       = azurerm_firewall.firewall
}

output "public_ip_id" {
  description = "The ID of the Public IP of the Firewall."
  value       = azurerm_public_ip.firewall_ip.id
}

output "management_ip_id" {
  description = "The ID of the Management IP of the Firewall."
  value       = azurerm_public_ip.firewall_management_ip.id
}

output "policy_id" {
  description = "The ID of the Firewall Policy."
  value       = azurerm_firewall_policy.firewall_policy.id
}

output "policy_object" {
  description = "The Firewall Policy object."
  value = azurerm_firewall_policy.firewall_policy
}
