variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group."
}

variable "location" {
  type        = string
  description = "(Required) The location of the resource."
}

variable "aks_name" {
  type        = string
  description = "(Required) The name of the AKS."
}

variable "aks_subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this AKS."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) Link to a Log Analytic Workspace."
}

variable "automatic_channel_upgrade" {
  type        = string
  default     = "none"
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable. (Default none)."
}

variable "azure_policy_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable Azure Policy (Default true)."
}

variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Specifies whether a Public FQDN for this Private Cluster should be added (Default true)."
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard and Premium. (Default Standard)."
}

variable "network_policy" {
  type        = string
  default     = "calico"
  description = "(Optional) Sets up network policy to be used with Azure CNI. supported values are Calico, Azure and Cilium (Default Calico)."
}

variable "default_node_pool_name" {
  type        = string
  default     = "agentpool"
  description = "(Optional) The name of the default Node Pool."
}

variable "default_node_pool_node_count" {
  type        = number
  default     = 2
  description = "(Optional) The node count for the default Node Pool."
}

variable "default_node_pool_vm_size" {
  type        = string
  default     = "Standard_D8ds_v5"
  description = "(Optional) The size of the VM in the default Node Pool."
}

variable "default_node_pool_only_critical_addons_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable only critical addons, default true."
}

variable "default_node_pool_os_disk_type" {
  type        = string
  default     = "Managed"
  description = "(Optional) The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Defaults to Managed."
}

variable "default_node_pool_enable_auto_scaling" {
  type        = bool
  default     = true
  description = "(Optional) Should the Kubernetes Auto Scaler be enabled for this Node Pool? defaults to true."
}

variable "default_node_pool_max_count" {
  type        = number
  default     = 5
  description = "(Optional) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
}

variable "default_node_pool_min_count" {
  type        = number
  default     = 2
  description = "(Optional) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
}

variable "default_node_pool_zones" {
  type        = list(string)
  default     = ["1", "2", "3"]
  description = "(Optional) Specifies a list of Availability Zones in which this Kubernetes Cluster should be located."
}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "(Optional) Specifies the type of Managed Service Identity that should be configured on this Kubernetes Cluster. Possible values are SystemAssigned or UserAssigned. Defaults to SystemAssigned."
}

variable "identity_ids" {
  type        = list(string)
  default     = null
  description = "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster."
}

variable "cluster_node_pools" {
  type = list(object({
    cluster_name = string
    vm_size      = string
  }))
  default     = []
  description = "(Optional) Add more Node Pools to the AKS."
}
