
resource "azurerm_linux_virtual_machine" "my_vm" {
  count               = var.numberofvms
  name                = "${var.env}vm-${count.index}"
  resource_group_name = var.resource_details.name
  location            = var.resource_details.location
  size                = var.vm_details.size
  admin_username      = var.vm_details.admin_username
  admin_password      = var.vm_details.admin_password
  network_interface_ids = [
    var.env == "dev" ? azurerm_network_interface.mynic[count.index].id : azurerm_network_interface.mynicqa[count.index].id
  ]
  disable_password_authentication = false
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
}
