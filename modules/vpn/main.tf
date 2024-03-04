resource "azurerm_public_ip" "vpn_first_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static" #TODO to var
  sku               = "Standard"
  zones             = var.public_ip_zones

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_public_ip" "vpn_second_ip" { #TODO make standard
  count               = var.active_active ? 1 : 0

  name                = var.second_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = var.second_public_ip_zones

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_public_ip" "point_to_site_configuration_ip" {
  name                = var.point_to_site_configuration_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = var.point_to_site_configuration_ip_zones

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_subnet" "gateway_subnet" { #TODO make standard

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  name                 = "GatewaySubnet"
  address_prefixes     = var.gateway_subnet_prefix

  enforce_private_link_endpoint_network_policies = true
}

locals {
  address_space = ["192.168.0.0/24"] #TODO to var 
  aad_tenant    = "https://login.microsoftonline.com/${var.tenant_id}/"
  aad_audience  = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
  aad_issuer    = "https://sts.windows.net/${var.tenant_id}/"
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = var.vpn_name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = var.type
  vpn_type = var.vpn_type

  active_active              = var.active_active
  private_ip_address_enabled = true
  sku                        = var.vpn_sku

  ip_configuration {
    name                          = "default"
    public_ip_address_id          = azurerm_public_ip.vpn_first_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  dynamic "ip_configuration" {
    for_each = var.active_active ? [1] : []

    content {
      name                          = "activeActive"
      public_ip_address_id          = azurerm_public_ip.vpn_second_ip[0].id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.gateway_subnet.id
    }
  }

  ip_configuration { #TODO make optional
    name                          = azurerm_public_ip.point_to_site_configuration_ip.name
    public_ip_address_id          = azurerm_public_ip.point_to_site_configuration_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  vpn_client_configuration {
    address_space        = local.address_space
    aad_tenant           = local.aad_tenant
    aad_audience         = local.aad_audience
    aad_issuer           = local.aad_issuer
    vpn_client_protocols = ["OpenVPN"] #TODO to var
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  vpn_diagnostic_setting_name                            = "${azurerm_virtual_network_gateway.vpn_gateway.name}-diagnostic-setting"
  vpn_first_ip_diagnostic_setting_name                   = "${azurerm_public_ip.vpn_first_ip.name}-diagnostic-setting"
  vpn_second_ip_diagnostic_setting_name                  = "${var.active_active ? azurerm_public_ip.vpn_second_ip[0].name : null}-diagnostic-setting"
  point_to_site_configuration_ip_diagnostic_setting_name = "${azurerm_public_ip.point_to_site_configuration_ip.name}-diagnostic-setting"

  vpn_enabled_logs = {
    "allLogs" = "categoryGroup"
    "audit"   = "categoryGroup"
  }

  vpn_first_ip_enabled_logs = {
    "allLogs" = "categoryGroup"
    "audit"   = "categoryGroup"
  }

  vpn_second_ip_enabled_logs = {
    "allLogs" = "categoryGroup"
    "audit"   = "categoryGroup"
  }

  point_to_site_configuration_enabled_logs = {
    "allLogs" = "categoryGroup"
    "audit"   = "categoryGroup"
  }
}

module "vpn_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.vpn_diagnostic_setting_name
  target_resource_id         = azurerm_virtual_network_gateway.vpn_gateway.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  enabled_logs               = local.vpn_enabled_logs
  save_all_metrics           = true
}

module "first_ip_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.vpn_first_ip_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip.vpn_first_ip.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  enabled_logs               = local.vpn_first_ip_enabled_logs
  save_all_metrics           = true
}

module "second_ip_logs" {
  count  = var.log_analytics_workspace_id == null || !var.active_active ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.vpn_second_ip_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip.vpn_second_ip[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  enabled_logs               = local.vpn_second_ip_enabled_logs
  save_all_metrics           = true
}

module "point_to_site_configuration_ip_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.point_to_site_configuration_ip_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip.point_to_site_configuration_ip.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  enabled_logs               = local.point_to_site_configuration_enabled_logs
  save_all_metrics           = true
}
