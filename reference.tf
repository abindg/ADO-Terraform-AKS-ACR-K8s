data "azurerm_resource_group" "rsg1" {
  name = var.rsg
}

data "azurerm_kubernetes_service_versions" "current" {
location = data.azurerm_resource_group.rsg1.location
include_preview = false
}

data "azurerm_subscription" "current" {
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

