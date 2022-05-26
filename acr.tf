resource "azurerm_container_registry" "acr" {
  name                = "${var.client}acr${random_string.abinrandom.result}"
  resource_group_name = data.azurerm_resource_group.rsg1.name
  location            = data.azurerm_resource_group.rsg1.location
  sku                 = "Standard"
  admin_enabled       = false
}

###Assigning the ACRpull role to the System Assigned Managed identity of aks Cluster with the ACR scope to enable AKS to pull docker images from ACR

resource "azurerm_role_assignment" "roleassign" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
