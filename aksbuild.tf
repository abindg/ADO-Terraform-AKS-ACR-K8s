resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${local.prefix}-aks"
  location            = data.azurerm_resource_group.rsg1.location
  resource_group_name = data.azurerm_resource_group.rsg1.name
  dns_prefix          = "${local.prefix}-aks"
  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${data.azurerm_resource_group.rsg1.name}-nrg"

  default_node_pool {
    name       = "default"
    zones = [1, 2, 3]
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    enable_auto_scaling = true
    type = "VirtualMachineScaleSets"
    os_disk_size_gb = 30
    max_count = 3
    min_count = 1
    node_labels = {
      "type" = "system"
      "apptype" = "web"
    }
    vnet_subnet_id = azurerm_subnet.subnet1.id
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  }

  azure_policy_enabled = true

  network_profile {
    load_balancer_sku = "standard"
    network_plugin = "azure"

  }

  tags = local.tag_owner
}

resource "azurerm_role_assignment" "aksroleassign" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_subscription.current.id
  skip_service_principal_aad_check = true
}


output "out2" {
  value = azurerm_kubernetes_cluster.aks.fqdn  
}

output "out3" {
  value = azurerm_kubernetes_cluster.aks.dns_prefix  
}

output "out4" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "out5" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "out6" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "out7" {
  value = azurerm_kubernetes_cluster.aks.portal_fqdn
}
