locals {
  firewall_ip_name            = "${var.firewall_name}-IP"
  firewall_management_ip_name = "${var.firewall_name}-management-IP"
  firewall_policy_name        = "${var.firewall_name}-policy"
  ip_allocation_method        = "Static"
} #TODO understand forced tunneling
#TODO forced tunneling - optional.

resource "azurerm_public_ip" "firewall_ip" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name              = local.firewall_ip_name
  allocation_method = local.ip_allocation_method
  sku               = var.ip_sku_tier

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_public_ip" "firewall_management_ip" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name              = local.firewall_management_ip_name
  allocation_method = local.ip_allocation_method
  sku               = var.ip_sku_tier

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_firewall" "firewall" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name               = var.firewall_name
  sku_name           = var.firewall_sku_name
  sku_tier           = var.firewall_sku_tier
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    name                 = azurerm_public_ip.firewall_ip.name
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_ip.id
  }

  management_ip_configuration {
    name                 = azurerm_public_ip.firewall_management_ip.name
    subnet_id            = var.firewall_management_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_management_ip.id
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}


resource "azurerm_firewall_policy" "firewall_policy" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name = local.firewall_policy_name
  dns { 
    proxy_enabled = true
    servers       = [] #TODO to var
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_network_rule_collection_group" {
  count              = length(var.network_rules) == 0 ? 0 : 1 #TODO more then one rule collection group

  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  name               = var.network_rule_collection_group_name
  priority           = 200

  network_rule_collection {
    name     = var.network_rule_collection_name
    action   = "Allow" #TODO deny
    priority = 1000

    dynamic "rule" {
      for_each = var.network_rules

      content {
        name                  = rule.value.name
        source_addresses      = rule.value.source_addresses
        source_ip_groups      = rule.value.source_ip_groups
        destination_addresses = rule.value.destination_addresses
        destination_fqdns     = rule.value.destination_fqdns
        destination_ip_groups = rule.value.destination_ip_groups
        destination_ports     = rule.value.destination_ports
        protocols             = rule.value.protocols
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_application_rule_collection_group" {
  count              = length(var.application_rules) == 0 ? 0 : 1

  name               = var.application_rule_collection_group_name
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 200 #TODO to var

  application_rule_collection {
    name     = var.application_rule_collection_name
    action   = "allow" #TODO deny
    priority = 1000

    dynamic "rule" {
      for_each = var.application_rules

      content {
        name                  = rule.value.name
        source_addresses      = rule.value.source_addresses
        source_ip_groups      = rule.value.source_ip_groups
        destination_addresses = rule.value.destination_addresses
        destination_fqdns     = rule.value.destination_fqdns
        destination_urls      = rule.value.destination_urls

        dynamic "http_headers" {
          for_each = rule.value.http_headers

          content {
            name  = http_header.key
            value = http_header.value
          }
        }

        dynamic "protocols" {
          for_each = rule.value.protocols

          content {
            port = protocol.key
            type = protocol.value
          }
        }
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_nat_rule_collection_group" {
  count              = length(var.nat_rules) == 0 ? 0 : 1
  name               = var.nat_rule_collection_group_name
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 200

  nat_rule_collection {
    name     = var.nat_rule_collection_name
    action   = "allow"
    priority = 1000

    dynamic "rule" {
      for_each = var.nat_rules

      content {
        name                = rule.value.name
        source_addresses    = rule.value.source_addresses
        source_ip_groups    = rule.value.source_ip_groups
        destination_address = rule.value.destination_address
        protocols           = rule.value.protocols
        translated_port     = rule.value.translated_port
        destination_ports   = rule.value.destination_ports
      }
    }
  }
}

locals {
  firewall_diagnostic_setting_name               = "${azurerm_firewall.firewall.name}-diagnostic-setting"
  firewall_ip_diagnostic_setting_name            = "${azurerm_public_ip.firewall_ip.name}-diagnostic-setting"
  firewall_management_ip_diagnostic_setting_name = "${azurerm_public_ip.firewall_management_ip.name}-diagnostic-setting"

  firewall_enabled_logs = { "allLogs" = "categoryGroup" }

  firewall_ip_enabled_logs = {
    "allLogs" = "categoryGroup"
    "audit"   = "categoryGroup"
  }

  firewall_management_ip_enabled_logs = {
    "allLogs" = "categoryGroup"
    "audit"   = "categoryGroup"
  }
}

module "firewall_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                           = local.firewall_diagnostic_setting_name
  target_resource_id             = azurerm_firewall.firewall.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  enabled_logs                   = local.firewall_enabled_logs
  save_all_metrics               = true
  log_analytics_destination_type = "Dedicated"
}

module "firewall_ip_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.firewall_ip_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip.firewall_ip.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  enabled_logs               = local.firewall_ip_enabled_logs
  save_all_metrics           = true
}

module "firewall_management_ip_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.firewall_management_ip_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip.firewall_management_ip.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  enabled_logs               = local.firewall_management_ip_enabled_logs
  save_all_metrics           = true
}
