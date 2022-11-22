
resource "azurerm_resource_group" "my_resg" {
  name     = "srinu"
  location = "eastus"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = "azurerm_resource_group.my_resg"
  address_spaces      = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.my_resg]
}