resource "azurerm_storage_account" "storage_account" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = var.account_type
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  access_tier                     = var.access_tier
  allow_nested_items_to_be_public = false
  queue_encryption_key_type       = var.queue_encryption_key_type
  table_encryption_key_type       = var.table_encryption_key_type


  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  default_storage_account_endpoint_name = "${var.storage_account_name}-private-endpoint"
}
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.storage_account_endpoint_name == null ? local.default_storage_account_endpoint_name : var.storage_account_endpoint_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.storage_account_endpoint_name}-connection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"] #TODO add
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  storage_account_diagnostic_setting_name          = "${azurerm_storage_account.storage_account.name}-diagnostic-setting"
  storage_account_endpoint_diagnostic_setting_name = "${azurerm_private_endpoint.private_endpoint.name}-diagnostic-setting"

  storage_account_services = toset(["blob", "table", "queue", "file"])
}

module "storage_account_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.storage_account_diagnostic_setting_name
  target_resource_id         = azurerm_storage_account.storage_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

}

module "storage_account_service_logs" {
  for_each = var.log_analytics_workspace_id == null ? [] : local.storage_account_services
  source   = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = "${local.storage_account_diagnostic_setting_name}-${each.value}"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/${each.value}Services/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "storage_account_endpoint_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.storage_account_endpoint_diagnostic_setting_name
  target_resource_id         = azurerm_private_endpoint.private_endpoint.network_interface[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
