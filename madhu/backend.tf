terraform {
  backend "azurerm" {
    resource_group_name  = "ntr"
    storage_account_name = "tony181122"
    container_name       = "tfcontainer"
    key                  = "adminkey"
  }
}