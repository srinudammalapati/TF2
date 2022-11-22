terraform {
  backend "azurerm" {
    resource_group_name  = "terraformbackend"
    storage_account_name = "qtterraformbackend"
    container_name       = "terraformstate"
    key                  = "vtire.tfstate"
  }
}
