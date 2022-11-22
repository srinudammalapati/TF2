resource "azurerm_resource_group" "my_resg" {
    name                = "fromterraform"
    location            = "central india" 
    tags                = {
        purpose         = "learning"
        env             = "dev"
         
    } 
    
  
}

resource "azurerm_virtual_network" "my_vnet" {
  name                   = "vnetfromtf"
  resource_group_name    = "fromterraform"
  location               = "central india"
  address_space = [ "192.168.0.0/16" ]

 depends_on = [
   azurerm_resource_group.my_resg
 ]
}

resource "azurerm_subnet" "surya" {
  name                 = "gopi"
  resource_group_name  = "fromterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.1.0/24"]
  depends_on = [
    azurerm_virtual_network.my_vnet
  ]
}

resource "azurerm_subnet" "kiran" {
  name                 = "ram"
  resource_group_name  = "fromterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.2.0/24"]
  depends_on = [
    azurerm_subnet.surya
  ]
}

resource "azurerm_subnet" "swami" {
  name                 = "siva"
  resource_group_name  = "fromterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.3.0/24"]
  depends_on = [
    azurerm_subnet.kiran
  ]
}

resource "azurerm_subnet" "rani" {
  name                 = "srinu"
  resource_group_name  = "fromterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.4.0/24"]
  depends_on = [
    azurerm_subnet.swami
  ]
}

resource "azurerm_subnet" "siva" {
  name                 = "nag"
  resource_group_name  = "fromterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.5.0/24"]
  depends_on = [
    azurerm_subnet.rani
  ]
}