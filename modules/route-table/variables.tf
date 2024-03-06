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
  description = "(Required) The name of the Route Table."
}

variable "routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = []

  description = "(Optional) A list of routes for the Route Table."
}

variable "associated_subnet_ids" {
  type = list(string)
  default = []

  description = "(Optional) A list of Subnets to be associated with the Route Table."
}
