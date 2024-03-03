variable "vm_name" {
  type        = string
  description = "(Required) the name of the virtual machine"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) the name of the resource group"
}

variable "location" {
  type        = string
  description = "(Required) the location of the resource"
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this virtual machine"
}

variable "availability_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Availability Zones in which this Linux Virtual Machine should be located."
}

variable "identities_list" {
  type        = list(string)
  nullable    = true
  default     = null
  description = "(Optional) attach user assigned identities, a list of identity IDs"
}

variable "vm_username" {
  type        = string
  description = "(Required) specify a a name for the admin user of the vm."
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "(Required) the password for the VM's admin user. sensitive value"
}

variable "vm_size" {
  type        = string
  description = "(Required) The SKU which should be used for this Virtual Machine."
}

variable "vm_type" {
  type        = string
  default     = "linux"
  description = "(Optional) type of virtual machine, can be linux or windows. default is linux."

  validation {
    condition     = contains(["linux", "windows"], var.vm_type)
    error_message = "error: not a valid vm type"
  }
}

variable "nic_ip_configuration_name" {
  type        = string
  default     = "ipconfig1"
  description = "(Optional) specify a name for the nic's IP Configuration."
}

variable "nic_ip_allocation_method" {
  type        = string
  default     = "Dynamic"
  description = "(Optional) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic."
}

variable "os_disk_caching" {
  type        = string
  default     = "ReadWrite"
  description = "(Optional) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite. Defaults to ReadWrite."
}

variable "os_disk_storage_account_type" {
  type        = string
  default     = "Premium_LRS"
  description = "(Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Defaults to Premium_LRS."
}

variable "source_image_reference" { #TODO make optional 
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  description = "(Required) specify the source image for your virtual machine. requires a publisher, offer, sku, and version."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) link resource to a log analytics workspace to enable logs."
}
