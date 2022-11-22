resource_details = {
  location        = "central india"
  name            = "resg1"
}

virtual_details = {
  address_space     = [ "192.168.0.0/16" ]
  name              = "vnet1"
}

subnets_details = {
  address_prefixes = [ "192.168.0.0/24" ]
  name =   "web"
}