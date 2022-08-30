variable "prefix" {
  type = string
  # default = "ak"
}
variable "ami" {
  type = string
}
variable "key_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "security_groups" {
  type = list(string)
}
variable "subnet_Id" {
  # type = string
}

variable "instance_profile" {
  type = string
  default = ""
}
variable "user_data_path" {
  type = string
  default = ""
}
