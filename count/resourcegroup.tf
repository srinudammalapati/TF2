resource "azurerm_resource_group" "ntire" { 
    name              = var.resourcegroup_details.name
    location          = var.resourcegroup_details.location
    tags              = {

      "project"       = "qtdevops"
    }

}

resource "azurerm_virtual_network" "ntire_vnet" {
  name                  = var.vnet_details.name
  resource_group_name   = var.resourcegroup_details.name
  location              = var.resourcegroup_details.location
  address_space         = var.vnet_details.address_space

  depends_on = [
    azurerm_resource_group.ntire
  ]
}

resource "azurerm_subnet" "subnets" {
    name                 = "subnet1"
    resource_group_name  = var.resourcegroup_details.name
    virtual_network_name = var.vnet_details.name
    address_prefixes     =  ["192.168.0.0/24"]
  
  depends_on = [
    azurerm_resource_group.ntire,
    azurerm_virtual_network.ntire_vnet

  ]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "mypublicipfromtf"
   resource_group_name   = var.resourcegroup_details.name
  location              = var.resourcegroup_details.location
  allocation_method   = "Dynamic "

  tags = {
    environment = "Production"
  }
}




resource "azurerm_network_interface" "ntire_nic" {
  name                = "nicfromtf"
  location            = var.resourcegroup_details.location
  resource_group_name = var.resourcegroup_details.name

  ip_configuration {
    name                          = "devconfiguration1"
    subnet_id                     = azurerm_subnet.subnets.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id 

  }
}

resource "azurerm_virtual_machine" "ntire_vm" {
  name                  = "vmfromtf"
  location              = var.resourcegroup_details.location
  resource_group_name   = var.resourcegroup_details.name
  network_interface_ids = [azurerm_network_interface.ntire_nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "srinu"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "srinu"
    admin_username = "srinu"
    admin_password = "srinu123!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}