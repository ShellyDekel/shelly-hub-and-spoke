variable "name" {
  type        = string
  description = "(Required) The name of the Diagnostic Setting."
}

variable "target_resource_id" {
  type        = string
  description = "(Required) The ID of the resource where logs should be enabled,"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "(Required) The ID of the Log Analytics Workspace to send the logs to."
}

variable "use_dedicated_tables" {
  type        = string
  default     = false
  description = "(Optional) When set to true, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. Not all resources support this feature."
}
