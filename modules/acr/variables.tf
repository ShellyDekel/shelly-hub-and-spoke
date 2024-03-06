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
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this ACR."
}

variable "name" {
  type        = string
  description = "(Required) The name of the ACR."
}

variable "sku" {
  type        = string
  description = "(Required) The SKU name of the ACR. Possible values are Basic, Standard and Premium."
}

variable "private_endpoint_name" {
  type        = string
  default     = null
  description = "(Optional) Name the Private Endpoint of the ACR."
}

variable "admin_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable Admin User, (default true)."
}

variable "dns_zone_name" {
  type        = string
  default     = "privatelink.azurecr.io"
  description = "(Optional) Name for the Private DNS Zone of the ACR."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) Link resource to a Log Analytics Workspace to enable logs."
}
