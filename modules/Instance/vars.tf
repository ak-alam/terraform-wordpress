variable "name" {
  type = string
  default = "ak"
}
variable "ami" {
  type = string
}
variable "keyName" {
  type = string
}
variable "instanceType" {
  type = string
}
variable "securityGroups" {
  type = list(string)
}
variable "subnetId" {
  type = string
}

variable "IAMInstanceProfile" {
  type = string
}
variable "userDataPath" {
  type = string
}
