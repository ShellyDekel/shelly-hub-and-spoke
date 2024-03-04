locals {
  monitor_spoke_resource_group_name = "shelly-monitor-spoke-terraform"
  monitor_spoke_location            = "West Europe" #TODO one location to rule them all
}

resource "azurerm_resource_group" "shelly_monitor_spoke" {
  name     = local.monitor_spoke_resource_group_name
  location = local.monitor_spoke_location

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  monitor_spoke_virtual_network_name = "${azurerm_resource_group.shelly_monitor_spoke.name}-vnet"
  monitor_spoke_address_spaces       = ["10.2.0.0/16"]

  monitor_spoke_subnets = jsondecode(file("./files/monitor-spoke-subnets.json"))
  monitor_spoke_nsg_name = "${azurerm_resource_group.shelly_monitor_spoke.name}-nsg"

  monitor_spoke_peering_vnets = {
    "shelly-hub-terraform-vnet" = "shelly-hub-terraform"
  }
}

module "shelly_monitor_spoke_vnet" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/virtual-network"

  virtual_network_name       = local.monitor_spoke_virtual_network_name
  address_spaces             = local.monitor_spoke_address_spaces
  subnets                    = local.monitor_spoke_subnets
  resource_group_name        = azurerm_resource_group.shelly_monitor_spoke.name
  location                   = azurerm_resource_group.shelly_monitor_spoke.location
  nsg_name                   = local.monitor_spoke_nsg_name
  peering_vnets              = local.monitor_spoke_peering_vnets
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
}

locals {
  monitor_spoke_vm_name                    = "${azurerm_resource_group.shelly_monitor_spoke.name}-vm"
  monitor_spoke_default_subnet_id          = module.shelly_monitor_spoke_vnet.subnets["default"].id
  monitor_spoke_availability_zone          = "1"
  monitor_spoke_vm_managed_identities_list = [module.log_access_identity.managed_identity.id]
  monitor_spoke_vm_size                    = "Standard_D2ds_v5"

  monitor_spoke_source_image = {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

module "shelly_monitor_spoke_vm" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/virtual-machine"

  vm_name                    = local.monitor_spoke_vm_name
  resource_group_name        = azurerm_resource_group.shelly_monitor_spoke.name
  location                   = azurerm_resource_group.shelly_monitor_spoke.location
  subnet_id                  = local.monitor_spoke_default_subnet_id
  identities_list            = local.monitor_spoke_vm_managed_identities_list
  vm_size                    = local.monitor_spoke_vm_size
  source_image_reference     = local.monitor_spoke_source_image
  vm_username                = var.monitor_spoke_vm_username
  vm_password                = var.monitor_spoke_vm_password
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id

}

locals {
  monitor_spoke_dns_zone_prefix = replace(azurerm_resource_group.shelly_monitor_spoke.name, "-", "")
  monitor_spoke_dns_zone_name   = "${local.monitor_spoke_dns_zone_prefix}.com"
}

resource "azurerm_private_dns_zone" "shelly_monitor_spoke_dns" {
  name                = local.monitor_spoke_dns_zone_name
  resource_group_name = azurerm_resource_group.shelly_monitor_spoke.name

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  monitor_spoke_log_analytics_access_identity = "${azurerm_resource_group.shelly_monitor_spoke.name}-log-access"
}

module "log_access_identity" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/managed-identity"

  resource_group_name = azurerm_resource_group.shelly_monitor_spoke.name
  location            = azurerm_resource_group.shelly_monitor_spoke.location
  identity_name       = local.monitor_spoke_log_analytics_access_identity

  role_assignments = {
    "Log Analytics Reader" = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
    "Reader"               = data.azurerm_subscription.subscription.id
  }
}

data "azurerm_subscription" "subscription" {}
