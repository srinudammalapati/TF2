output "my_vnetid" {
    value = azurerm_virtual_network.my_vnet.id
  
}

output "resourcegroup_name" {
    value = azurerm_resource_group.my_group.name
  
}

output "location" {
    value = azurerm_resource_group.my_group.location
  
}

output "subnet1id" {
    value = azurerm_subnet.subnet1.id
  
}

output "my_vnetname" {
    value = azurerm_virtual_network.my_vnet.name
  
}