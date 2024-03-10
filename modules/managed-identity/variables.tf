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
  description = "(Required) The name of the User Assigned Identity."
}

variable "role_assignments" {
  type = list(object({
    role_definition_name = string
    scope                = string
  }))
  default     = []
  description = "(Optional) The Role Assignments for the Identity."
}
