variable "resourcegroup_details" {
    type = object ({
        name         = string 
        location     = string
    })

    default           = {
      location        = "eastus"
      name            = "my_resg"
    }
  }

  variable "vnet_details" {
    type               = object ({
        name           = string
        address_space  = list(string)
    })
  }

  