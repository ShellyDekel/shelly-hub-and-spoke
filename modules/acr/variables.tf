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
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this ACR."
}

variable "acr_name" {
  type        = string
  description = "(Required) the name of the acr"
}

variable "sku" {
  type        = string
  description = "(Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium."
}

variable "private_endpoint_name" {
  type        = string
  default     = null
  description = "(Optional) name the private endpoint of the ACR."
}

variable "admin_enabled" {
  type        = bool
  default     = true
  description = "(Optional) enable admmin user, (default true)."
}

variable "dns_zone_name" {
  type        = string
  default     = "privatelink.azurecr.io"
  description = "(Optional) name for the private dns zone of the acr."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) link resource to a log analytics workspace to enable logs."
}
