resource "azurerm_resource_group" "my_resg" {
    name           = var.resourcegroup_details.name
    location       = var.resourcegroup_details.location

    tags           = {
      project      = "qtdevops"
    }
    
    }