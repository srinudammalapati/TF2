resource "azurerm_resource_group" "my_resg" {
    name              = var.resource_details.name
    location          = var.resource_details.location
    tags              = {
      "project"       = "devops"
    }
}

resource "azurerm_virtual_network" "vnet" {
   name = var.network_details.name
   location = var.resource_details.location
   resource_group_name = var.resource_details.name
   address_space = var.network_details.address_space
   depends_on = [
     azurerm_resource_group.my_resg
   ]
}

resource "azurerm_subnet" "subnets" {
    count = length(var.subnets_details.name)
  name = var.subnets_details.name[count.index]
  resource_group_name = var.resource_details.name
  virtual_network_name = var.network_details.name
  address_prefixes =  [ var.subnets_details.address_prefixes[count.index] ]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_public_ip" "my_pubip" {
  name                = "publicipfromtf"
   location = var.resource_details.location
   resource_group_name = var.resource_details.name
  allocation_method   = "Dynamic"

  depends_on = [
    azurerm_resource_group.my_resg
  ]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsgfromtf"
  location = var.resource_details.location
   resource_group_name = var.resource_details.name

  security_rule {
    name                       = "test123"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [
    azurerm_resource_group.my_resg
  ]
}
resource "azurerm_network_interface" "nic" {
  name                = "nicfromtf"
  location = var.resource_details.location
   resource_group_name = var.resource_details.name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[2].id
    public_ip_address_id = azurerm_public_ip.my_pubip.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}

resource "azurerm_network_interface_security_group_association" "nic_nsgassociation" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [
    azurerm_network_interface.nic,
    azurerm_network_security_group.nsg
  ]
}
resource "azurerm_linux_virtual_machine" "vmfrom_tf" {
  name                  = "webfromtf"
 location = var.resource_details.location
   resource_group_name = var.resource_details.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  computer_name                   = "srinu"
  admin_username                  = "srinu"
  admin_password                   = "srinu@123" 
  disable_password_authentication = false
  
  depends_on = [
    azurerm_network_interface.nic
  ]
}