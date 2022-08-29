variable "name" {
  type = string
  default = "ak"
}
variable "vpcId" {
  type = string
}
variable "ingressTraffic" {
  type = map
}
variable "protocol" {}
variable "prefix" {}