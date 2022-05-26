resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${local.prefix}-logws-${random_string.abinrandom.result}"
  location            = data.azurerm_resource_group.rsg1.location
  resource_group_name = data.azurerm_resource_group.rsg1.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = local.tag_owner
}