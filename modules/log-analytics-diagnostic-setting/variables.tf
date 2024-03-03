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

variable "log_analytics_destination_type" {
  type        = string
  default     = null
  description = "(Optional) Possible values are AzureDiagnostics and Dedicated. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
}

variable "enabled_logs" {
  type        = map(string)
  default     = {}
  description = "(Optional) a list of logs to save, format is  {log name = log type (category/categoryGroup)}. not all resources have category groups available."
}

variable "save_all_metrics" {
  type        = bool
  default     = false
  description = "(Optional) save all metrics. default false."
}

variable "metrics" {
  type        = list(string)
  default     = []
  description = "(Optional) a list of metrics to save."
}
