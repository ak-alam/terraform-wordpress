variable "prefix" {
  type = string
  # default = "ak"
}
variable "vpc" {
  type = object({
  vpc_cidr = string
  public_subnet = list(string)
  private_subnet = list(string)
  })  
}

