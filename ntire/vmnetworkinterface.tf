resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  resource_group_name = var.resource_details.name
  location            = var.resource_details.location

  security_rule {
    name                       = "ssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [
    azurerm_resource_group.my_resg
  ]
}


resource "azurerm_public_ip" "my_public_ip" {
  count               = 3
  name                = var.ip_details[count.index]
  resource_group_name = var.resource_details.name
  location            = var.resource_details.location
  allocation_method   = "Dynamic"
  depends_on = [
    azurerm_resource_group.my_resg
  ]
}


resource "azurerm_network_interface" "mynic" {
  count               = 3
  name                = var.nic_details[count.index]
  resource_group_name = var.resource_details.name
  location            = var.resource_details.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip[count.index].id
  }
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_public_ip.my_public_ip
  ]
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  count                     = 3
  network_interface_id      = azurerm_network_interface.mynic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_network_interface.mynic
  ]
}
