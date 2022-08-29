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
variable "sourceSG" {
type = list
default = []
}
variable "protocol" {}
variable "prefix" {}