variable "resource_group_name" {
  type        = string
  description = "(Required) the name of the resource group"
}

variable "location" {
  type        = string
  description = "(Required) the location of the resource"
}

variable "identity_name" {
  type        = string
  description = "(Required) the name of the user assigned identity"
}

variable "role_assignments" {
  type        = map(string)
  default     = {}
  description = "(Optional) the role assignments for the identity, format is {role_definition_name = scope}"
}
