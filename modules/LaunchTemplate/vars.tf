variable "prefix" {
  type = string
  # default = "ASGTemplate"
}
variable "name" {
  type = string
  # default = "ASGTemplate"
}
variable "ami" {
  
}
variable "instance_type" {
  
}
variable "key_name" {

}
variable "security_groups" {
    type = list(string)
}
variable "instance_profile" {
  
}
variable "DB_HOST" {
  type = string
}
variable "user_data" {}