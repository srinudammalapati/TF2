
variable "numberofvms" {
  type        = number
  description = "(optional) describe your variable"
}
variable "name" {
  type        = string
  description = "(optional) describe your variable"
}
variable "resourcegroup_details" {
  type = object({
    name     = string
    location = string
  })
}

variable "virtualnetwork_details" {
  type = object({
    address_space = list(string)
  })

}
variable "subnet_details" {
  type = object({
    address_prefixes = list(string)
  })
}

variable "authentication_details" {
    type = object ({
       username   = string
        password = string
    })
}

variable "null_version" {
    type = string
    description = "(optional) describe your variable"
}