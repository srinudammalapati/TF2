module "ntire" {
  source = "./ntire"

  resource_details = {
    location = "centralindia"
    name = "soda"
  }
  virtual_details = {
    address_space = [ "192.168.0.0/16" ]
    name = "beer"
  }
  subnets_details = {
    address_prefixes = [ "192.168.0.0/24","192.168.1.0/24", "192.168.2.0/24" ]
    name = [ "book","pen", "pencil" ]
  }
  runingversion = "1.5"
  vm_details = {
    admin_password = "test@123"
    admin_username = "qttest"
    name = [ "vm1", "vm2" ]
    size = "standard_B1s"
  }
  nic_details = ["vmnic1", "vmnic2"]
  ip_details = ["vmip1", "vmip2"]
}
