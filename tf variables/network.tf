resource "azurerm_resource_group" "my_resg" {
    name          = var.resource_group_name
    location      = var.target_region
    tags          = {
        purpose   = "learning"
        env       = "dev"
    }
    
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "vnetfromtf"
  location            = var.target_region
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  depends_on = [
    azurerm_resource_group.my_resg
  ]
}