/*
resource "azurerm_public_ip" "dockerhost_pubip" {
  name                = "${local.prefix}-pubip"
  resource_group_name = data.azurerm_resource_group.rsg1.name
  location            = data.azurerm_resource_group.rsg1.location
  allocation_method   = "Dynamic"
}



resource "azurerm_network_interface" "dockerhost_vnic" {
  name                = "${local.prefix}-vnic"
  resource_group_name = data.azurerm_resource_group.rsg1.name
  location            = data.azurerm_resource_group.rsg1.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "20.0.1.10"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.dockerhost_pubip.id
  }
}
*/