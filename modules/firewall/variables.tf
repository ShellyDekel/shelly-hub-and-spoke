variable "resource_group_name" {
  type        = string
  description = "(Required) the name of the resource group"
}

variable "location" {
  type        = string
  description = "(Required) the location of the resource"
}


variable "firewall_name" {
  type        = string
  description = "(Required) the name of the firewall."
}

variable "firewall_sku_name" {
  type        = string
  default     = "AZFW_VNet"
  description = "(Optional) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Defaults to AZFW_VNet."
}

variable "firewall_sku_tier" {
  type        = string
  default     = "Standard"
  description = "(Optional) the SKU tier of the firewall, possible values are Premium, Standard and Basic. Defaults to Standard."
}

variable "ip_sku_tier" {
  type        = string
  default     = "Standard"
  description = "(Optional) the SKU tier of the firewall's public IP's, Possible values are Standard and Basic. Defaults to Standard."
}

variable "network_rule_collection_group_name" {
  type        = string
  default     = "DefaultNetworkRuleCollectionGroup"
  description = "(Optional) the name of the default network rule collection group."
}

variable "network_rule_collection_name" {
  type        = string
  default     = "DefaultNetworkRuleCollection"
  description = "(Optional) the name of the default network rule collection."
}

variable "network_rules" {
  type = list(object({
    name                  = string
    source_addresses      = list(string)
    source_ip_groups      = list(string)
    destination_addresses = list(string)
    destination_fqdns     = list(string)
    destination_ports     = list(string)
    destination_ip_groups = list(string)
    protocols             = list(string)
  }))
  default = []

  description = "(Optional) a list of network rules. the network rule format is: {name, source_addresses/ip_groups, destination_addresses/fqdns/ip_groups, destination_ports, protocols}."
}

variable "application_rules" {
  type = list(object({
    name                  = string
    source_addresses      = list(string)
    source_ip_groups      = list(string)
    destination_addresses = list(string)
    destination_fqdns     = list(string)
    destination_urls      = list(string)

    protocols = map(string)

    http_headers = map(string)
  }))
  default = []

  description = "(Optional) a list of application rules. the application rule format is: {name, source_addresses/ip_groups, destination_addresses/fqdns/urls, protocols: {port = type (Http, Https, or Mssql)}, http_headers: {name = value}}"
}

variable "application_rule_collection_group_name" {
  type        = string
  default     = "DefaultApplicationRuleCollectionGroup"
  description = "(Optional) the name of the default application rule collection group."
}

variable "application_rule_collection_name" {
  type        = string
  default     = "DefaultApplicationRuleCollection"
  description = "(Optional) the name of the default application rule collection."
}

variable "nat_rule_collection_group_name" {
  type        = string
  default     = "DefaultNatRuleCollectionGroup"
  description = "(Optional) the name of the default nat rule collection group."
}

variable "nat_rule_collection_name" {
  type        = string
  default     = "DefaultNatRuleCollection"
  description = "(Optional) the name of the default nat rule collection."
}

variable "nat_rules" {
  type = list(object({
    name                = string
    source_addresses    = list(string)
    source_ip_groups    = list(string)
    destination_address = list(string)
    destination_ports   = list(string)
    protocols           = list(string)
    translated_port     = list(string)
  }))
  default = []

  description = "(Optional) a list of nat rules. the nat rule format is: {name, source_addresses/ip_groups, destination_address, destination_ports, protocols, translated port}."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) link resource to a log analytics workspace to enable logs."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) the name of the virtual network the firewall will sit on"
}

variable "firewall_subnet_id" {
  type        = string
  description = "(Required) the id of the firewall subnet"
}

variable "firewall_management_subnet_id" {
  type        = string
  description = "(Required) the id of the firewall management subnet"
}
