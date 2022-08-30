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

#Role Variables
variable "role_name" {
  type = string
  # default = "SSM"
}

variable "source_sg"{
  type = list
  default = []
}
variable "lb_IngressTraffic" {
  type = map
  default = {
   "80" = ["0.0.0.0/0"]
  }
}
variable "db_IngressTraffic" {
  type = map
  default = {
   "3306" = ["0.0.0.0/0"]
   "22" = ["0.0.0.0/0"]
  }
}
variable "jumphost_IngressTraffic" {
  type = map
  default = {

   "22" = ["0.0.0.0/0"]
  }  
}

variable "web_IngressTraffic" {
  type = map
  default = {
   "80" = ["0.0.0.0/0"]
   "22" = ["0.0.0.0/0"]
  }
}

#Variable Instances 
variable "ami" {
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
#Load balancer
variable "deregistration_delay" {}
variable "tg_settings" {}
variable "target_instance" {
  type = string
  default = ""
}

variable "template_name" {}

variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "healthCheck_grace_period" {}