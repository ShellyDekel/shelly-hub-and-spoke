locals {
  dns_prefix = replace(var.aks_name, "-", "")
}

resource "azurerm_kubernetes_cluster" "azure_kubernetes_service" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = local.dns_prefix

  private_cluster_enabled             = var.private_cluster_enabled
  automatic_channel_upgrade           = var.automatic_channel_upgrade
  azure_policy_enabled                = var.azure_policy_enabled
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  sku_tier                            = var.sku_tier


  default_node_pool {
    name                         = var.default_node_pool_name
    node_count                   = var.default_node_pool_node_count
    vm_size                      = var.default_node_pool_vm_size
    only_critical_addons_enabled = var.default_node_pool_only_critical_addons_enabled
    os_disk_type                 = var.default_node_pool_os_disk_type
    vnet_subnet_id               = var.aks_subnet_id
    enable_auto_scaling          = var.default_node_pool_enable_auto_scaling
    max_count                    = var.default_node_pool_max_count
    min_count                    = var.default_node_pool_min_count
    zones                        = var.default_node_pool_zones
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }


  auto_scaler_profile {
    skip_nodes_with_local_storage = false
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id == null ? [] : [1]
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id

    }
  }

  network_profile {
    network_plugin = "kubenet" #TODO not hard coded
    dns_service_ip = "10.0.0.10"
    service_cidr   = "10.0.0.0/16"
    network_policy = var.network_policy
  }

  lifecycle {
    ignore_changes = [
      tags["Environment"], tags["CreationDateTime"]
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "name" {
  for_each              = var.cluster_node_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.azure_kubernetes_service.id
  vm_size               = each.value
}

locals {
  diagnostic_setting_name = "${azurerm_kubernetes_cluster.azure_kubernetes_service.name}-diagnostic-setting"
  enabled_logs = {
    "kube-apiserver"           = "category"
    "kube-audit"               = "category"
    "kube-audit-admin"         = "category"
    "kube-controller-manager"  = "category"
    "kube-scheduler"           = "category"
    "cluster-autoscaler"       = "category"
    "cloud-controller-manager" = "category"
    "guard"                    = "category"
    "csi-azuredisk-controller" = "category"
    "csi-azurefile-controller" = "category"
    "csi-snapshot-controller"  = "category"
  }
}

module "logs" {
  count  = var.log_analytics_workspace_id == null ? 0 : 1
  source = "../log-analytics-diagnostic-setting"

  name                           = local.diagnostic_setting_name
  target_resource_id             = azurerm_kubernetes_cluster.azure_kubernetes_service.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  enabled_logs                   = local.enabled_logs
  save_all_metrics               = true
  log_analytics_destination_type = "Dedicated"
}
