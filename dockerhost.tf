/*
resource "azurerm_linux_virtual_machine" "dockerhost" {
  name                            = "${local.prefix}-${var.hostname}"
  resource_group_name             = data.azurerm_resource_group.rsg1.name
  location                        = data.azurerm_resource_group.rsg1.location
  size                            = "Standard_DS2_v2"
  admin_username                  = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.dockerhost_vnic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.ssh_public_key)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

 # custom_data = filebase64("${path.module}/app-scripts/bootstrap.sh")

  tags = local.tag_owner

}

output "vm_pub_ip" {
    value = azurerm_linux_virtual_machine.dockerhost.public_ip_address
  
}

resource "azurerm_role_assignment" "dockerhostroleassign" {
  principal_id                     = azurerm_linux_virtual_machine.dockerhost.identity[0].principal_id
  role_definition_name             = "Contributor"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "local_file" "conffile" {
  depends_on = [
    azurerm_container_registry.acr,
    azurerm_linux_virtual_machine.dockerhost,
    data.azurerm_resource_group.rsg1
  ]
    content  = templatefile("app-scripts/bootscript.tftpl",
    {
        "acr_name" = azurerm_container_registry.acr.name
    }) 
    filename = "bootstrap.sh"
}


resource "null_resource" "temp" {
  depends_on = [
    azurerm_linux_virtual_machine.dockerhost,
    azurerm_role_assignment.dockerhostroleassign
  ]

 connection {
    type     = "ssh"
    user     = "adminuser"
    private_key = "${file(var.ssh_private_key)}"
    host     = azurerm_linux_virtual_machine.dockerhost.public_ip_address
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  } 

  provisioner "remote-exec" {
    inline = [
      "sed -e 's/\r//g' /tmp/bootstrap.sh > /tmp/bootstrap_new.sh",
      "chmod +x /tmp/bootstrap_new.sh",
      "/tmp/bootstrap_new.sh"
    ]
  }
}
*/

