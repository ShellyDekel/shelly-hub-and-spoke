resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  address_space       = var.address_spaces
  location            = var.location
  resource_group_name = var.resource_group_name
  #TODO add dns servers

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  name                 = each.key
  address_prefixes     = each.value.address_prefixes

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_network_security_group" "default_subnet_nsg" {
  name                = var.nsg_name
  resource_group_name = var.resource_group_name
  location            = var.location
  #TODO add rules
  #TODO On nic? 

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_to_subnet_association" {
  for_each = {for key, value in azurerm_subnet.subnets : key => value if var.subnets[value.name].requires_nsg}

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.default_subnet_nsg.id
}

resource "azurerm_virtual_network_peering" "network_peerings" {
  for_each = var.peering_vnets
  #TODO destroy and recreate

  name                         = "${each.key}-to-${azurerm_virtual_network.virtual_network.name}"
  resource_group_name          = each.value
  virtual_network_name         = each.key
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = !(var.has_remote_gateway)
  use_remote_gateways          = var.has_remote_gateway
}

locals {
  vnet_diagnostic_setting_name = "${azurerm_virtual_network.virtual_network.name}-diagnostic-setting"
  nsg_diagnostic_setting_name  = "${azurerm_network_security_group.default_subnet_nsg.name}-diagnostic-setting"
}

module "vnet_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.vnet_diagnostic_setting_name
  target_resource_id         = azurerm_virtual_network.virtual_network.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "nsg_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.nsg_diagnostic_setting_name
  target_resource_id         = azurerm_network_security_group.default_subnet_nsg.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
