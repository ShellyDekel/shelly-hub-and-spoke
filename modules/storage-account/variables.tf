variable "resource_group_name" {
  type        = string
  description = "(Required) the name of the resource group"
}

variable "location" {
  type        = string
  description = "(Required) the location of the resource"
}

variable "storage_account_name" {
  type        = string
  description = "(Required) the name of the storage account"
}

variable "storage_account_endpoint_name" {
  type    = string
  default = null

  description = "(Optional) specify a name for the private endpoint of the storage account"
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for the Private Endpoint of the Storage Account."
}

variable "account_type" {
  type        = string
  default     = "StorageV2"
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2."
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "(Optional) Defines the Tier to use for this storage account. Valid options are Standard and Premium. Defaults to Standard."
}

variable "account_replication_type" {
  type        = string
  default     = "RAGRS"
  description = "(Optional) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Defaults to RAGRS"
}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
}

variable "queue_encryption_key_type" {
  type        = string
  default     = "Service"
  description = "(Optional) The encryption type of the queue service. Possible values are Service and Account. Default value is Service."
}

variable "table_encryption_key_type" {
  type        = string
  default     = "Service"
  description = "(Optional) The encryption type of the table service. Possible values are Service and Account. Default value is Service."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "(Optional) link resource to a log analytics workspace to enable logs."
}
