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
        name           = list(string)
        address_space  = list(string)
    })
  
}

variable "subnets_details" {
    type = object ({
        name              = list(string)
        address_prefixes  = list(string)
    })
  
}
