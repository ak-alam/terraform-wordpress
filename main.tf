#VPC modules
module "vpc" {
  source = "./modules/VPC"
  vpc = {
    vpc_cidr = var.vpc_["vpc_cidr"]
    public_subnet = var.vpc_["public_subnet"]
    private_subnet = var.vpc_["private_subnet"]
  }
  prefix = "akbar"
}

#IAM Role modules
module "ssmrole" {
  source = "./modules/Roles"
  role_name = var.role_name
  policy_path = file("${path.module}/polices/ssm.json")
}

#Security Group modules
module "lb-Sg" {
  source = "./modules/SecurityGroup"
  vpc_id = module.vpc.vpcId
  ingress_traffic = var.lb_IngressTraffic
  protocol = "tcp"
  prefix = "lb"
}

module "db-sg" {
  source = "./modules/SecurityGroup"
  vpc_id = module.vpc.vpcId
  ingress_traffic = var.db_IngressTraffic
  protocol = "tcp"
  prefix = "DB"
}

module "jumphost-sg"{
 source = "./modules/SecurityGroup"
  vpc_id = module.vpc.vpcId
  ingress_traffic = var.jumphost_IngressTraffic
  protocol = "tcp"
  prefix = "jumphost"
}

module "web-sg" {
  source = "./modules/SecurityGroup"
  vpc_id = module.vpc.vpcId
  ingress_traffic = var.web_IngressTraffic
  protocol = "tcp"
  prefix = "web"
}

# # #Instances modules
module "dbInstances" {
  source = "./modules/Instance"
  ami = var.ami
  key_name = var.key_name
  instance_type = var.instance_type
  security_groups = [ "${module.db-sg.security_group}" ]
  subnet_Id = module.vpc.private_subnet.0
  instance_profile = module.ssmrole.instance_profile
  user_data_path = file("${path.module}/userdata/db-installation.sh")
  prefix = "db"
}

module "jumpServer" {
  source = "./modules/Instance"
  ami = var.ami
  key_name = "ak-alam.pem"
  instance_type = var.instance_type
  security_groups = [ "${module.jumphost-sg.security_group}" ]
  subnet_Id = module.vpc.public_subnet.0
  instance_profile = module.ssmrole.instance_profile
  # userDataPath = ""
  prefix = "jump"
}


# Load balancers modules
module "networkLB" {
  source = "./modules/LB"
  internal = true #for internal & external LB (true=internal, false=external)
  type = "network"
  security_groups = null
  vpc_Id = module.vpc.vpcId
  subne_Ids = module.vpc.private_subnet
  deregistration_delay = var.deregistration_delay
  target_instance = module.dbInstances.instance
  tg_vars = local.nlb.0
  prefix = "nlb"

}

module "applicationLB" {
  source = "./modules/LB"
  internal = false 
  type = "application"
  security_groups = ["${module.lb-Sg.security_group}"]
  subne_Ids = module.vpc.public_subnet
  vpc_Id = module.vpc.vpcId
  deregistration_delay = var.deregistration_delay
  tg_vars = local.alb.1
  prefix = "alb"

}

# #Launch Template

module "template" {
  source = "./modules/LaunchTemplate"
  name = var.name
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  instance_profile = module.ssmrole.instance_profile
  security_groups = [ "${module.web-sg.security_group}" ]
  DB_HOST = module.networkLB.lb_dns
  user_data = "userdata/wp-installation.sh"
  prefix = "asg"
}

module "ASG" {
  source = "./modules/ASG"
  name = var.name
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  health_check_grace_period = var.healthCheck_grace_period
  vpc_id = module.vpc.vpcId
  target_group_arns = [module.applicationLB.target_arns]
  template_id = module.template.asg_template
  prefix = "asg-server"
  postfix = "akbar"
}