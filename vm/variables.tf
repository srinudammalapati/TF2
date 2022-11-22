variable "resource_details" {
    type          =object ({
        name      = string
        location  = string
    })
  
}

variable "network_details" {
    type               = object ({
        name           = string
        address_space  = list(string) 
    })
  
}

variable "subnets_details" {
    type                   = object({
        name               = list(string)
        address_prefixes   = list(string)
    })
  
}