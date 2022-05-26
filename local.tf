locals {
  prefix = "${var.client}"
  tag_owner = {
      owner = "abin.duttagupta"
  }
  image_name = "${azurerm_container_registry.acr.name}.azurecr.io/${var.client}app"
}