resource "azurerm_resource_group" "my_group" {
    name               = var.resource_details.name
    location           = var.resource_details.location
    tags               = {
        project        = "devops"
    } 
}

resource "azurerm_virtual_network" "my_vnet" {
   count = length(var.virtual_details.name)
    name                  = var.virtual_details.name[count.index]
    resource_group_name   = var.resource_details.name
    location              = var.resource_details.location
    address_space         = [ var.virtual_details.address_space[count.index] ]
    depends_on = [
      azurerm_resource_group.my_group
    ]
  
}

resource "azurerm_subnet" "subnets" {
    count                 = length(var.subnets_details.name)
    name                  = var.subnets_details.name[count.index]
    resource_group_name   = var.resource_details.name
    virtual_network_name  = var.virtual_details.name[count.index]
    address_prefixes      = [var.subnets_details.address_prefixes[count.index]]
    depends_on = [
      azurerm_virtual_network.my_vnet
    ]
  
}