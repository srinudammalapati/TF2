resource "azurerm_network_security_group" "web_nsg" {
  name                = "webnsg"
  resource_group_name = var.resource_details.name
  location            = var.resource_details.location
  security_rule {
    name                       = "openssh"
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
    name                       = "openhttp"
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
    azurerm_resource_group.my_group
  ]
}

resource "azurerm_public_ip" "web_public_ip" {
  count = 2
  name                = var.ip_details[count.index]
  resource_group_name = var.resource_details.name
  location            = var.resource_details.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "terraform.workspace"
  }
  depends_on = [
    azurerm_resource_group.my_group
  ]
}

resource "azurerm_network_interface" "web_nic" {
  count = 2
  name                = var.nic_details[count.index]
  resource_group_name = var.resource_details.name
  location            = var.resource_details.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    public_ip_address_id          = azurerm_public_ip.web_public_ip[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.subnets,
    azurerm_public_ip.web_public_ip
  ]
}



resource "azurerm_network_interface_security_group_association" "webnsg_web_nic_assoc" {
  count =2
  network_interface_id      = azurerm_network_interface.web_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
  depends_on = [
    azurerm_network_interface.web_nic,
    azurerm_network_security_group.web_nsg
  ]
}
