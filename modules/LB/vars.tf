variable "name" {
  type = string
  default = "ak"
}

variable "lbSchema" {
  type = bool
}
variable "lbType" {
  type = string
}
variable "securityGroups" {
  type = list(string)
  default = []
}
variable "subneIds"{
    type = list(string)
}

variable "vpcId" {}
variable "protocol"{}
variable "port" {}
variable "deregistrationDelay" {}
variable "path" {
  type = string
  default = ""
}
variable "healthyThreshold" {
  
}
variable "targetInstance" {
  
}