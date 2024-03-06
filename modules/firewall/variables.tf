variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group."
}

variable "location" {
  type        = string
  description = "(Required) The location of the resource."
}


variable "name" {
  type        = string
  description = "(Required) The name of the Firewall."
}

variable "sku_name" {
  type        = string
  default     = "AZFW_VNet"
  description = "(Optional) The SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Defaults to AZFW_VNet."
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "(Optional) The SKU tier of the firewall. Possible values are Premium, Standard and Basic. Defaults to Standard."
}

variable "ip_sku_tier" {
  type        = string
  default     = "Standard"
  description = "(Optional) The SKU tier of the Firewall's public IP's. Possible values are Standard and Basic. Defaults to Standard."
}

variable "network_rule_collection_group_name" {
  type        = string
  default     = "DefaultNetworkRuleCollectionGroup"
  description = "(Optional) The name of the default Network Rule Collection Group."
}

variable "network_rule_collection_name" {
  type        = string
  default     = "DefaultNetworkRuleCollection"
  description = "(Optional) The name of the default Network Rule Collection."
}

variable "network_rules" {
  type = list(object({
    name                  = string
    source_addresses      = optional(list(string))
    source_ip_groups      = optional(list(string))
    destination_addresses = optional(list(string))
    destination_fqdns     = optional(list(string))
    destination_ports     = optional(list(string))
    destination_ip_groups = optional(list(string))
    protocols             = list(string)
  }))
  default = []

  description = "(Optional) A list of Network Rules."
}

variable "application_rules" {
  type = list(object({
    name                  = string
    source_addresses      = optional(list(string))
    source_ip_groups      = optional(list(string))
    destination_addresses = optional(list(string))
    destination_fqdns     = optional(list(string))
    destination_urls      = optional(list(string))

    protocols = map(string)

    http_headers = map(string)
  }))
  default = []

  description = "(Optional) A list of Application Rules."
}

variable "application_rule_collection_group_name" {
  type        = string
  default     = "DefaultApplicationRuleCollectionGroup"
  description = "(Optional) The name of the default Application Rule Collection Group."
}

variable "application_rule_collection_name" {
  type        = string
  default     = "DefaultApplicationRuleCollection"
  description = "(Optional) The name of the default Application Rule Collection."
}

variable "nat_rule_collection_group_name" {
  type        = string
  default     = "DefaultNatRuleCollectionGroup"
  description = "(Optional) The name of the default NAT Rule Collection Group."
}

variable "nat_rule_collection_name" {
  type        = string
  default     = "DefaultNatRuleCollection"
  description = "(Optional) The name of the default NAT Rule Collection."
}

variable "nat_rules" {
  type = list(object({
    name                = string
    source_addresses    = optional(list(string))
    source_ip_groups    = optional(list(string))
    destination_address = optional(list(string))
    destination_ports   = optional(list(string))
    protocols           = list(string)
    translated_port     = list(string)
  }))
  default = []

  description = "(Optional) A list of NAT Rules."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) Link the resource to a Log Analytics Workspace to enable logs."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) The name of the Virtual Network the Firewall will sit on."
}

variable "firewall_subnet_id" {
  type        = string
  description = "(Required) The ID of the Firewall Subnet"
}

variable "firewall_management_subnet_id" {
  type        = string
  description = "(Required) The ID of the Firewall Management Subnet."
}
