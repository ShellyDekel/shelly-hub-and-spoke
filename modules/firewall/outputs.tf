output "id" {
  description = "the id of the firewall"
  value       = azurerm_firewall.firewall.id
}

output "name" {
  description = "the name of the firewall"
  value       = azurerm_firewall.firewall.name
}

output "private_ip_ranges" {
  description = "the private ip ranges of the firewall"
  value       = azurerm_firewall.firewall.private_ip_ranges
}

output "firewall_object" {
  description = "the firewall object"
  value       = azurerm_firewall.firewall
}

output "public_ip_id" {
  description = "the id of the public ip of the firewall"
  value       = azurerm_public_ip.firewall_ip.id
}

output "management_ip_id" {
  description = "the id of the management ip of the firewall"
  value       = azurerm_public_ip.firewall_management_ip.id
}

output "policy_id" {
  description = "the id of the firewall policy"
  value       = azurerm_firewall_policy.firewall_policy.id
}

output "policy_object" {
  value = azurerm_firewall_policy.firewall_policy
}
