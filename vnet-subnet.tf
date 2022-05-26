resource "azurerm_virtual_network" "vnet1" {
    name = "${local.prefix}-vnet"
    resource_group_name = data.azurerm_resource_group.rsg1.name
    location            = data.azurerm_resource_group.rsg1.location
    address_space       = ["20.0.0.0/16"] 
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${local.prefix}-subnet"
  resource_group_name  = data.azurerm_resource_group.rsg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["20.0.1.0/24"]
}