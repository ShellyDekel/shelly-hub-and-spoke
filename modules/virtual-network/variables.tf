variable "resource_group_name" {
  type = string
  description = "(Required) the name of the resource group"
}

variable "location" {
  type = string
  description = "(Required) the location of the resource"
}

variable "virtual_network_name" {
  type = string

  description = "(Required) the name of the virtual network"
}

variable "address_spaces" {
  type = list(string)

  description = "(Required) the private ip address of the vnet"
}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
    requires_nsg     = bool
  }))

  description = "(Required) a list of subnets for the virtual network, format is {name = {address_prefixes, requires_nsg}}"
}

variable "nsg_name" {
  type        = string
  description = "(Required) the name of the default nsg"
}

variable "peering_vnets" {
  type        = map(string)
  default     = {}
  description = "(Optional) create peering to other vnets, format is {vnet-name = resource group name}"
}

variable "has_remote_gateway" {
  type        = bool
  default     = false
  description = "(Optional) does the this virtual network have a remote gateway (vpn), if true, allows peering vnets to use the vpn, if false, enables vnet to use remote vpn through peering connections. default false."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) link resource to a log analytics workspace to enable logs."
}
