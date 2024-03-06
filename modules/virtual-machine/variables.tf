variable "name" {
  type        = string
  description = "(Required) The name of the Virtual Machine."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group."
}

variable "location" {
  type        = string
  description = "(Required) The location of the resource."
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this VM."
}

variable "availability_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Availability Zones in which this VM should be located."
}

variable "identities_list" {
  type        = list(string)
  nullable    = true
  default     = null
  description = "(Optional) A list of User Assigned Identity IDs to attatch to the VM."
}

variable "vm_username" {
  type        = string
  description = "(Required) The name for the VM's Admin User."
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "(Required) The password for the VM's Admin User. Sensitive value."
}

variable "size" {
  type        = string
  description = "(Required) The SKU which should be used for this Virtual Machine."
}

variable "type" {
  type        = string
  default     = "Linux"
  description = "(Optional) The type of VM to create, can be Linux or Windows. defaults to Linux."

  validation {
    condition     = contains(["Linux", "Windows"], var.type)
    error_message = "error: not a valid VM type."
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
  description = "(Optional) The type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite. Defaults to ReadWrite."
}

variable "os_disk_storage_account_type" {
  type        = string
  default     = "StandardSSD_LRS"
  description = "(Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Defaults to StandardSSD_LRS."
}

variable "source_image_reference" { #TODO make optional 
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  description = "(Required) Specify the Source Image for the VM."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) Link resource to a Log Analytics Workspace to enable logs."
}
