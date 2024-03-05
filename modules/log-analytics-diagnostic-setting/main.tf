resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                           = var.name
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.use_dedicated_tables ? "Dedicated" : "AzureDiagnostics"

  dynamic "enabled_log" {
    iterator = "category_group"
    for_each = data.azurerm_monitor_diagnostic_categories.log_categories.log_category_groups

    content {
      category_group = category_group.value
    }
  }

  dynamic "enabled_log" {
    iterator = "category"
    for_each = data.azurerm_monitor_diagnostic_categories.log_categories.logs

    content {
      category_group = category_group.value
    }
  }

  dynamic "metric" {
    iterator = "metric"
    for_each = data.azurerm_monitor_diagnostic_categories.log_categories.metrics

    content {
      category = metric.value
    }
  }
}

data "azurerm_monitor_diagnostic_categories" "log_categories" {
  resource_id = var.target_resource_id
}
