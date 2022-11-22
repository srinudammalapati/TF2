variable "resource_details" {
    type = object ({
        name        = string
        location    = string
    })
    default = {
      location      = "eastus"
      name          = "my_resg"
    }
}

variable "virtual_details" {
    type = object ({
        name           = string
        address_space  = list(string)
    })
  
}

variable "subnets_details" {
    type = object ({
        name              = list(string)
        address_prefixes  = list(string)
    })
  
}
variable "runingversion" {
    type = string
    default = "1.0"
  
}
 variable "vm_details" {
    type = object({
        name = list(string)
        admin_username = string
        admin_password = string
        size =string


    })
   
 }
variable "nic_details" {
  type=list(string)
}
variable "ip_details" {
  type=list(string)
}