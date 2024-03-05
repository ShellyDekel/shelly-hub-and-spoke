variable "name" {
  type        = string
  description = "(Required) the name of the connection"
}

variable "target_resource_id" {
  type        = string
  description = "(Required) the id of the resource where logs should be enabled"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "(Required) the id of the log analytics workspace to send the logs to"
}

variable "use_dedicated_tables" {
  type        = string
  default     = false
  description = "(Optional) When set to true, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. Not all resources support this feature."
}
