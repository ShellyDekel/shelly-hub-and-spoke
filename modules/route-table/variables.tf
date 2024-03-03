variable "resource_group_name" {
  type        = string
  description = "(Required) the name of the resource group"
}

variable "location" {
  type        = string
  description = "(Required) the location of the resource"
}

variable "route_table_name" {
  type        = string
  description = "(Required) the name of the route table"
}

variable "routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = []

  description = "(Optional) a list of routes for the routing table. format is: [{name, addres_prefix, next_hop_type, next_hop_in_ip_address}]"
}

variable "associated_subnet_ids" {
  type = set(string)
  default = []

  description = "(Optional) associate the route table to subnets."
}
