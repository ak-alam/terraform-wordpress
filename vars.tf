variable "name" {
  type = string
  default = "ak"
}
#VPC Variables
variable "vpc_" {
  type = object({
  vpc_cidr = string
  public_subnet = list(string)
  private_subnet = list(string)
  })  
}

#IAM Variables
variable "role_name" {
  type = string
  # default = "SSM"
}

#Security Groups

variable "source_SG"{
  type = list
  default = []
}
variable "lb_IngressTraffic" {
  type = map
  # default = {
  #   80 = ["0.0.0.0/0"]
  # }
}
# variable "protocol" {}
# variable "prefix" {}
variable "db_IngressTraffic" {
  type = map
  # default = {
  #   3306 = ["0.0.0.0/0"]
  # }
}
variable "web_IngressTraffic" {
  type = map
}

#Variable Instances 
variable "ami_" {
  type = string
  default = ""
}
variable "key_name" {
  type = string
  default = "akbar.pem"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
