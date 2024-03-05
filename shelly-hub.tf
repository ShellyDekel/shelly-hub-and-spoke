locals {
  hub_resource_group_name = "shelly-hub-terraform"
}

resource "azurerm_resource_group" "shelly_hub" {
  name     = local.hub_resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}


locals {
  hub_virtual_network_name = "${azurerm_resource_group.shelly_hub.name}-vnet"
  hub_nsg_name             = "${azurerm_resource_group.shelly_hub.name}-network-security-group"
  hub_vnet_address_spaces  = ["10.0.0.0/16"]

  hub_subnets = jsondecode(file("./files/hub-subnets.json"))

  hub_peering_vnets = {
    "shelly-work-spoke-terraform-vnet"    = "shelly-work-spoke-terraform",
    "shelly-monitor-spoke-terraform-vnet" = "shelly-monitor-spoke-terraform"
  }
  hub_has_remote_gateway = true
}
module "shelly_hub_vnet" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/virtual-network"

  virtual_network_name       = local.hub_virtual_network_name #TODO name variable
  location                   = azurerm_resource_group.shelly_hub.location
  resource_group_name        = azurerm_resource_group.shelly_hub.name
  address_spaces             = local.hub_vnet_address_spaces
  subnets                    = local.hub_subnets
  nsg_name                   = local.hub_nsg_name
  peering_vnets              = local.hub_peering_vnets
  has_remote_gateway         = local.hub_has_remote_gateway
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
}


locals {
  hub_firewall_name                 = "${azurerm_resource_group.shelly_hub.name}-firewall"
  hub_network_rule_collection_name  = "${local.hub_firewall_name}-allowed-network-rules"
  hub_firewall_subnet_id            = module.shelly_hub_vnet.subnets["AzureFirewallSubnet"].id
  hub_firewall_management_subnet_id = module.shelly_hub_vnet.subnets["AzureFirewallManagementSubnet"].id
  hub_firewall_network_rules        = jsondecode(file("./files/hub-firewall-rules.json")).network_rules
  hub_firewall_application_rules    = jsondecode(file("./files/hub-firewall-rules.json")).application_rules
  hub_firewall_nat_rules            = jsondecode(file("./files/hub-firewall-rules.json")).nat_rules
}

module "shelly_hub_firewall" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/firewall"

  firewall_name                 = local.hub_firewall_name
  resource_group_name           = azurerm_resource_group.shelly_hub.name
  virtual_network_name          = module.shelly_hub_vnet.name
  location                      = azurerm_resource_group.shelly_hub.location
  network_rules                 = local.hub_firewall_network_rules
  application_rules             = local.hub_firewall_application_rules
  nat_rules                     = local.hub_firewall_nat_rules
  network_rule_collection_name  = local.hub_network_rule_collection_name
  firewall_subnet_id            = local.hub_firewall_subnet_id
  firewall_management_subnet_id = local.hub_firewall_management_subnet_id
  log_analytics_workspace_id    = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
}


locals {
  hub_vpn_name                  = "${azurerm_resource_group.shelly_hub.name}-vpn"
  hub_vpn_sku                   = "VpnGw2AZ"
  hub_gateway_subnet_prefix     = ["10.0.3.0/24"]
  hub_active_active             = true
  hub_vpn_first_ip_name         = "${local.hub_vpn_name}-first-IP"
  hub_vpn_second_ip_name        = "${local.hub_vpn_name}-second-IP"
  hub_vpn_point_to_site_ip_name = "${local.hub_vpn_name}-point-to-site-IP"
  hub_vpn_type                  = "Vpn"
  hub_vpn_ip_availability_zones = ["1", "2", "3"]
}

data "azurerm_client_config" "client" {}

module "shelly_hub_vpn" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/vpn"

  resource_group_name                  = azurerm_resource_group.shelly_hub.name
  location                             = azurerm_resource_group.shelly_hub.location
  vpn_name                             = local.hub_vpn_name
  virtual_network_name                 = module.shelly_hub_vnet.name
  gateway_subnet_prefix                = local.hub_gateway_subnet_prefix
  vpn_sku                              = local.hub_vpn_sku
  active_active                        = local.hub_active_active
  type                                 = local.hub_vpn_type
  public_ip_name                       = local.hub_vpn_first_ip_name
  second_public_ip_name                = local.hub_vpn_second_ip_name
  point_to_site_configuration_ip_name  = local.hub_vpn_point_to_site_ip_name
  public_ip_zones                      = local.hub_vpn_ip_availability_zones
  second_public_ip_zones               = local.hub_vpn_ip_availability_zones
  point_to_site_configuration_ip_zones = local.hub_vpn_ip_availability_zones
  tenant_id                            = data.azurerm_client_config.client.tenant_id
  log_analytics_workspace_id           = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id

}

locals {
  hub_route_table_name                  = "${azurerm_resource_group.shelly_hub.name}-route-table"
  hub_route_table_associated_subnet_ids = toset([module.shelly_hub_vnet.subnets["default"].id, module.shelly_work_spoke_vnet.subnets["default"].id, module.shelly_monitor_spoke_vnet.subnets["default"].id])
  hub_route_table_routes                = jsondecode(file("./files/hub-route-table-routes.json")).routes

}

module "shelly_hub_route_table" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/route-table"

  route_table_name      = local.hub_route_table_name
  resource_group_name   = azurerm_resource_group.shelly_hub.name
  location              = azurerm_resource_group.shelly_hub.location
  associated_subnet_ids = local.hub_route_table_associated_subnet_ids
  routes                = local.hub_route_table_routes
}

locals {
  hub_acr_name          = "shellyhubterraformacr"
  hub_acr_sku           = "Standard"
  hub_default_subnet_id = module.shelly_hub_vnet.subnets["default"].id
}

module "shelly_hub_acr" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/acr"

  resource_group_name        = azurerm_resource_group.shelly_hub.name
  location                   = azurerm_resource_group.shelly_hub.location
  subnet_id                  = local.hub_default_subnet_id
  acr_name                   = local.hub_acr_name
  sku                        = local.hub_acr_sku
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
}


locals {
  hub_log_analytics_workspace_name = "${azurerm_resource_group.shelly_hub.name}-log-analytics-workspace"
}

resource "azurerm_log_analytics_workspace" "shelly_hub_log_analytics" {
  name                = local.hub_log_analytics_workspace_name
  resource_group_name = azurerm_resource_group.shelly_hub.name
  location            = azurerm_resource_group.shelly_hub.location

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  log_analytics_diagnostic_setting_name = "${azurerm_log_analytics_workspace.shelly_hub_log_analytics.name}-diagnostic-setting"
  enabled_logs = {
    "allLogs" = "categoryGroup"
    "audit"   = "categoryGroup"
  }
}

module "log_analytics_logs" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/log-analytics-diagnostic-setting"

  name                       = local.log_analytics_diagnostic_setting_name
  target_resource_id         = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
  enabled_logs               = local.enabled_logs
  save_all_metrics           = true #TODO to module
}
