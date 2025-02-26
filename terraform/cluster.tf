resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.environment
  kubernetes_version      = var.kubernetes_version
  location                = var.location
  resource_group_name     = var.environment
  dns_prefix              = "${var.environment}-dns"
  sku_tier                = "Paid"
  private_cluster_enabled = false

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
#    network_policy     = "calico"
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_cidr
    service_cidr       = var.aks_service_cidr
  }

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(var.public_ssh_key, "\n", "")
    }
  }

  default_node_pool {
    name                  = var.aks_core_pool.name
    orchestrator_version  = var.kubernetes_version
    vm_size               = var.aks_core_pool.vm_size
    os_disk_size_gb       = var.aks_core_pool.disk_size
    vnet_subnet_id        = module.network.vnet_subnets[0]
    # availability_zones    = ["1"]
    type                  = "VirtualMachineScaleSets"
    enable_auto_scaling   = true
    node_count            = null
    min_count             = var.aks_core_pool.min_count
    max_count             = var.aks_core_pool.max_count
    max_pods              = 110
    enable_node_public_ip = false
    node_labels           = { "components" : var.aks_core_pool.name }
    tags                  = local.common_tags
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
    kube_dashboard {
      enabled = false
    }
    azure_policy {
      enabled = false
    }
    oms_agent {
      enabled = false
    }
  }

  role_based_access_control {
    enabled = false
  }

  tags = local.common_tags

  depends_on = [module.network]
}

# resource "azurerm_kubernetes_cluster_node_pool" "pool" {
#   for_each = var.aks_node_pools
# 
#   name = each.key
#   node_labels = {
#     "components" : each.key
#   }
# 
#   tags = merge(
#     local.common_tags,
#     {
#       "Name" = "${var.environment}-${each.key}"
#     }
#   )
# 
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#   vnet_subnet_id        = module.network.vnet_subnets[0]
#   # availability_zones    = ["1"]
#   vm_size               = each.value.vm_size
#   enable_auto_scaling   = true
#   node_count            = each.value.node_count
#   min_count             = each.value.min_count
#   max_count             = each.value.max_count
#   os_disk_size_gb       = each.value.disk_size
#   max_pods              = 110
# 
#   lifecycle {
#     # Ignore changes in node count caused by autoscaling
#     ignore_changes = [node_count]
#   }
# }
