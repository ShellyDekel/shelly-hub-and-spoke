resource "azurerm_container_registry" "container_registry" {
  name                          = var.acr_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  default_endpoint_name           = "${azurerm_container_registry.container_registry.name}-private-endpoint"
  private_service_connection_name = "${local.default_endpoint_name}-connection"
}

resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = var.private_endpoint_name == null ? local.default_endpoint_name : var.private_endpoint_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = local.private_service_connection_name
    private_connection_resource_id = azurerm_container_registry.container_registry.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_private_dns_zone.id]
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }

}

resource "azurerm_private_dns_zone" "acr_private_dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  acr_diagnostic_setting_name = "${azurerm_container_registry.container_registry.name}-diagnostic-setting"
  acr_enabled_logs = {
    "audit" = "categoryGroup"
    allLogs = "categoryGroup"
  }
}

module "acr-logs" {
  source = "../log-analytics-diagnostic-setting"
  count  = var.log_analytics_workspace_id == null ? 0 : 1

  name                       = local.acr_diagnostic_setting_name
  target_resource_id         = azurerm_container_registry.container_registry.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  enabled_logs               = local.acr_enabled_logs
  save_all_metrics           = true
}

locals {
  endpoint_nic_diagnostic_setting_name = "${azurerm_private_endpoint.acr_private_endpoint.name}-diagnostic-setting"
}

module "private_endpoint_nic_logs" {
  source = "../log-analytics-diagnostic-setting"
  count  = var.log_analytics_workspace_id == null ? 0 : 1

  name                       = local.endpoint_nic_diagnostic_setting_name
  target_resource_id         = azurerm_private_endpoint.acr_private_endpoint.network_interface[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  save_all_metrics           = true
}
