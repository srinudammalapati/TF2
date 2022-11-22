resource "azurerm_resource_group" "my_res_gr" {
  name         = "qtterraform"
  location     = "central india"
  tags         = {
    projects   = "understanding"
    env        = "dev"
  }
}

resource "azurerm_virtual_network" "my_vir_net" { 
  name                = "vnetfromtf"
  location            = "central india"
  resource_group_name = "qtterraform"
  address_space       = ["192.168.0.0/16"]
}  

resource "azurerm_subnet" "subnet1" {
  name                 = "srinu1"
  resource_group_name  = "qtterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.1.0/24"]
}

# explicit dependency to wait till virtual network is created
depends_on = [  
  azurerm_virtual_network.my_vir_net
]

resource "azurerm_subnet" "gopi" {
  name                 = "srinu2"
  resource_group_name  = "qtterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.2.0/24"]
}

resource "azurerm_subnet" "srinu" {
  name                 = "srinu3"
  resource_group_name  = "qtterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.3.0/24"]
}

resource "azurerm_subnet" "sai" {
  name                 = "srinu4"
  resource_group_name  = "qtterraform"
  virtual_network_name = "vnetfromtf"
  address_prefixes     = ["192.168.4.0/24"]
}