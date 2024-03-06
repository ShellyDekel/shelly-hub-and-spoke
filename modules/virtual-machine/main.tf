locals {
  types = {
    "linux" = "Linux"
    "windows" = "Windows"
  }
}

resource "azurerm_network_interface" "network_interface" {
  name                          = "${var.name}-nic"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  enable_accelerated_networking = true

  ip_configuration {
    name                          = var.nic_ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.nic_ip_allocation_method
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  count                           = var.type == local.types["linux"] ? 1 : 0

  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false #TODO to var
  encryption_at_host_enabled      = false

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  vtpm_enabled        = true #TODO whats vtpm
  zone                = var.availability_zone
  secure_boot_enabled = true

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "identity" {
    for_each = var.identities_list == null ? [] : [false]

    content {
      type         = "UserAssigned"
      identity_ids = var.identities_list
    }
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"], tags["scheduling"]
    ]
  }
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  count = var.type == local.types["windows"] ? 1 : 0

  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  size                       = var.size
  admin_username             = var.vm_username
  admin_password             = var.vm_password
  encryption_at_host_enabled = false

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  vtpm_enabled        = true
  zone                = var.availability_zone
  secure_boot_enabled = true

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type #TODO to standard ssd
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "identity" {
    for_each = var.identities_list == null ? [] : [false]

    content {
      type         = "UserAssigned" #TODO add system 
      identity_ids = var.identities_list
    }
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

locals {
  vm_nic_diagnostic_setting_name = "${azurerm_network_interface.network_interface.name}-diagnostic-setting"
}

module "vm_nic_logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting"

  name                       = local.vm_nic_diagnostic_setting_name
  target_resource_id         = azurerm_network_interface.network_interface.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
#TODO add option for data disk.