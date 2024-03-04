locals {
  work_spoke_resource_group_name = "shelly-work-spoke-terraform"
  work_spoke_location            = "West Europe"
}

resource "azurerm_resource_group" "shelly_work_spoke" {
  name     = local.work_spoke_resource_group_name
  location = local.work_spoke_location

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  work_spoke_virtual_network_name = "${azurerm_resource_group.shelly_work_spoke.name}-vnet"
  work_spoke_address_spaces       = ["10.1.0.0/16"]

  work_spoke_subnets = jsondecode(file("./files/work-spoke-subnets.json"))

  work_spoke_nsg_name = "${azurerm_resource_group.shelly_work_spoke.name}-nsg"

  work_spoke_peering_vnets = {
    "shelly-hub-terraform-vnet" = "shelly-hub-terraform"
  }
}

module "shelly_work_spoke_vnet" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/virtual-network"

  resource_group_name        = azurerm_resource_group.shelly_work_spoke.name
  location                   = azurerm_resource_group.shelly_work_spoke.location
  virtual_network_name       = local.work_spoke_virtual_network_name
  address_spaces             = local.work_spoke_address_spaces
  subnets                    = local.work_spoke_subnets
  nsg_name                   = local.work_spoke_nsg_name
  peering_vnets              = local.work_spoke_peering_vnets
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
}

locals {
  work_spoke_vm_name                    = "${azurerm_resource_group.shelly_work_spoke.name}-vm"
  work_spoke_default_subnet_id          = module.shelly_work_spoke_vnet.subnets["default"].id
  work_spoke_availability_zone          = "1"
  work_spoke_vm_managed_identities_list = [module.shelly_work_spoke_acr_access.managed_identity.id]
  work_spoke_vm_size                    = "Standard_D2ds_v5"

  work_spoke_source_image = {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

module "shelly_work_spoke_vm" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/virtual-machine"

  vm_name                    = local.work_spoke_vm_name
  resource_group_name        = azurerm_resource_group.shelly_work_spoke.name
  location                   = azurerm_resource_group.shelly_work_spoke.location
  subnet_id                  = local.work_spoke_default_subnet_id
  availability_zone          = local.work_spoke_availability_zone
  identities_list            = local.work_spoke_vm_managed_identities_list
  vm_size                    = local.work_spoke_vm_size
  source_image_reference     = local.work_spoke_source_image
  vm_username                = var.work_spoke_vm_username
  vm_password                = var.work_spoke_vm_password
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id

}

locals {
  work_spoke_acr_access_identity = "${azurerm_resource_group.shelly_work_spoke.name}-acr-access"
}

module "shelly_work_spoke_acr_access" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/managed-identity"

  resource_group_name = azurerm_resource_group.shelly_work_spoke.name
  location            = azurerm_resource_group.shelly_work_spoke.location
  identity_name       = local.work_spoke_acr_access_identity
  role_assignments = {
    "AcrPull" = module.shelly_hub_acr.id
    "AcrPush" = module.shelly_hub_acr.id
  }
}

locals {
  work_spoke_aks_name                       = "${azurerm_resource_group.shelly_work_spoke.name}-aks"
  work_spoke_aks_subnet_id                  = module.shelly_work_spoke_vnet.subnets["aks-subnet"].id
  work_spoke_automatic_channel_upgrade      = "patch"
  work_spoke_default_node_pool_os_disk_type = "Ephemeral"
}

module "shelly_work_spoke_aks" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/aks"

  resource_group_name            = azurerm_resource_group.shelly_work_spoke.name
  location                       = azurerm_resource_group.shelly_work_spoke.location
  aks_name                       = local.work_spoke_aks_name
  aks_subnet_id                  = local.work_spoke_aks_subnet_id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
  automatic_channel_upgrade      = local.work_spoke_automatic_channel_upgrade
  default_node_pool_os_disk_type = local.work_spoke_default_node_pool_os_disk_type
}

locals {
  work_spoke_storage_account_name          = replace(azurerm_resource_group.shelly_work_spoke.name, "-", "")
  work_spoke_storage_account_endpoint_name = "${local.work_spoke_storage_account_name}-private-endpoint"
  work_spoke_access_tier                   = "Cool" #TODO change to default
  work_spoke_queue_encryption_key_type     = "Account"
  work_spoke_table_encryption_key_type     = "Account"
}

module "shelly_work_spoke_storage_account" {
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/modules/storage-account"

  resource_group_name           = azurerm_resource_group.shelly_work_spoke.name
  location                      = azurerm_resource_group.shelly_work_spoke.location
  storage_account_name          = local.work_spoke_storage_account_name
  storage_account_endpoint_name = local.work_spoke_storage_account_endpoint_name
  subnet_id                     = local.work_spoke_default_subnet_id
  access_tier                   = local.work_spoke_access_tier
  queue_encryption_key_type     = local.work_spoke_queue_encryption_key_type
  table_encryption_key_type     = local.work_spoke_table_encryption_key_type
  log_analytics_workspace_id    = azurerm_log_analytics_workspace.shelly_hub_log_analytics.id
}
