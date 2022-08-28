variable "name" {
  type = string
  default = "ak"
}
variable "vpc" {
  type = object({
  vpcCidr = string
  publicSubnet = list(string)
  privateSubnet = list(string)
  })  
}

