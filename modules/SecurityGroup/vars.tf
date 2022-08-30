variable "name" {
  type = string
  default = "akbar"
}
variable "vpc_id" {
  type = string
}
variable "ingress_traffic" {
  type = map
}
variable "protocol" {}
variable "prefix" {}