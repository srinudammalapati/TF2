resource "azurerm_resource_group" "my_resg" {
    name          = "resourcegfromtf"
    location      = "eastus"
    tags          = {
        purpose   = "learning"
        env       = "dev"
    }
    
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "vnetfromtf"
  location            = "eastus"
  resource_group_name = "resourcegfromtf"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "storageaccountfromtf"
  resource_group_name      = "resourcegfromtf"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags                     = {
    environment            = "test"
    purpose                = "learning"
  }
}