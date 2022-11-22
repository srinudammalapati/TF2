resource "azurerm_resource_group" "my_resg" {
  name = var.resource_details.name
  location = var.resource_details.location
  tags = {
    "env" = "dev"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name = var.network_details.name
  resource_group_name = var.resource_details.name
  location = var.resource_details.location
  address_space = var.network_details.address_space
  depends_on = [
    azurerm_resource_group.my_resg
  ]
}

resource "azurerm_subnet" "subnets" {
    count = length(var.subnets_details.name)
    name = var.subnets_details.name[count.index]
    resource_group_name = var.resource_details.name
    virtual_network_name = var.network_details.name
    address_prefixes = [var.subnets_details.address_prefixes[count.index]]
    depends_on = [
      azurerm_resource_group.my_resg,
      azurerm_virtual_network.vnet
    ]
  
}