variable "resource_group_name" {
    type = string
    default = "my_resgr"
}

variable "address_space" {
    type = list(string)
    default = [ "192.168.0.0/16" ]
}

variable "target_region" {
    type = string
    default = "eastus"
  
}