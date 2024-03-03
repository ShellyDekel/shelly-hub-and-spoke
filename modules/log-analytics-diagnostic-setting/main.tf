resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                           = var.name
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "enabled_log" {
    for_each = var.enabled_logs

    content {
      category       = enabled_log.value == "category" ? enabled_log.key : null
      category_group = enabled_log.value == "categoryGroup" ? enabled_log.key : null
    }
  }

  dynamic "metric" {
    for_each = var.save_all_metrics ? [1] : []

    content {
      category = "AllMetrics"
    }
  }

  dynamic "metric" {
    for_each = var.metrics

    content {
      category = metric.value
    }
  }
}
