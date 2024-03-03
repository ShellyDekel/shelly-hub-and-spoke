variable "resource_group_name" {
  type        = string
  description = "(Required) the name of the resource group"
}

variable "location" {
  type        = string
  description = "(Required) the location of the resource"
}

variable "vpn_name" {
  type        = string
  description = "(Required) the name of the vpn"
}

variable "vpn_sku" {
  type        = string
  description = "(Required) Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ."
}

variable "public_ip_name" {
  type        = string
  description = "(Required) the name of the VPN's public ip"
}

variable "public_ip_zones" {
  type        = set(string)
  description = "(Required) a list of availability zones for the public ip address of the vpn"
}

variable "active_active" {
  type        = bool
  default     = false
  description = "(Optional) If true, an active-active Virtual Network Gateway will be created. If false, an active-standby gateway will be created. Defaults to false."
}

variable "second_public_ip_name" {
  type    = string
  default = null

  description = "(Optional) name of the active-active public IP. Required if active_active is set to true."
}

variable "second_public_ip_zones" {
  type    = set(string)
  default = null

  description = "(Optional) a list of availability zones for the public ip address of the vpn. Required if active_active is set to true."
}

variable "type" {
  type        = string
  description = "(Required) The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute."
}

variable "vpn_type" {
  type        = string
  default     = "RouteBased"
  description = "(Optional) The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased."
}

variable "point_to_site_configuration_ip_name" {
  type        = string
  description = "(Required) the name of the VPN's point-to-site configuration ip"
}

variable "point_to_site_configuration_ip_zones" {
  type        = set(string)
  description = "(Required) a list of availability zones for the point-to-site configuration ip address of the vpn"
}

variable "tenant_id" {
  type        = string
  description = "(Required) the tenant ID, required for point-to-site configuration."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) the name of the virtual network the firewall will sit on"
}

variable "gateway_subnet_prefix" {
  type        = list(string)
  description = "(Required) the address prefix for the firewall subnet"
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) link resource to a log analytics workspace to enable logs."
}
