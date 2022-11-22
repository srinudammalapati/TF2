resource "azurerm_mssql_server" "mssqlserver" {
  name                         = format ("qtmssqlserverfromtf%s", terraform.workspace)
 resource_group_name           = var.resource_details.name
    location                   = var.resource_details.location
  version                      = "12.0"
  administrator_login          = "devops"
  administrator_login_password = "testing@123"
  minimum_tls_version          = "1.2"
  public_network_access_enabled = true
  depends_on = [
    azurerm_virtual_network.my_vnet,
    azurerm_subnet.subnets
  ]
}

resource "azurerm_mssql_database" "mssqldb" {
  name           = format ("qtmssqldbfromtf%s", terraform.workspace)
  server_id      = azurerm_mssql_server.mssqlserver.id
  sku_name       = "basic"
  sample_name    = "AdventureWorksLT"  

  tags           = {
    env           = "terraform.workspace"
  }
  depends_on = [
    azurerm_mssql_server.mssqlserver
  ]
}