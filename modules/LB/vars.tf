variable "prefix" {
  type = string
  # default = "ak"
}

variable "internal" {
  type = bool
}
variable "type" {
  type = string
}
variable "security_groups" {
  type = list(string)
  default = [""]
}
variable "subne_Ids"{
    type = list(string)
}

variable "vpc_Id" {}
variable "nlb"{
  type = map
  default = {
    "3306"="TCP"
  }
}

variable "tg_vars"{}
variable "target_instance" {
  type = string
  default = ""
}
variable "deregistration_delay" {}
