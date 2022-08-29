#VPC modules
module "vpc" {
  source = "./modules/VPC"
  vpc = {
    vpcCidr = var.vpc_["vpc_cidr"]
    publicSubnet = var.vpc_["public_subnet"]
    privateSubnet = var.vpc_["private_subnet"]
  }
  name = local.prefix
}
#IAM modules
module "IAM" {
  source = "./modules/IAM"
  roleName = var.role_name
  policyPath = file("${path.module}/polices/ssm.json")
}

#Security Group modules
module "lb-Sg" {
  source = "./modules/SecurityGroup"
  vpcId = module.vpc.vpcId_out
  ingressTraffic = var.lb_IngressTraffic
  protocol = "tcp"
  sourceSG = var.source_SG
  prefix = "ALB"

  name = local.prefix
}

module "db-sg" {
  source = "./modules/SecurityGroup"
  vpcId = module.vpc.vpcId_out
  ingressTraffic = var.db_IngressTraffic
  protocol = "tcp"
  sourceSG = var.source_SG
  prefix = "DB"

  name = local.prefix
}

module "web-sg" {
  source = "./modules/SecurityGroup"
  vpcId = module.vpc.vpcId_out
  ingressTraffic = var.web_IngressTraffic
  protocol = "tcp"
  sourceSG = ["${module.lb-Sg.securityGroupId_out}"]
  prefix = "web"

  name = local.prefix
}

#Instances modules
module "dbInstances" {
  source = "./modules/Instance"
  ami = var.ami_
  keyName = var.key_name
  instanceType = var.instance_type
  securityGroups = [ "${module.db-sg.securityGroupId_out}" ]
  subnetId = module.vpc.privateSubnet_out.0
  IAMInstanceProfile = module.IAM.instanceProfile
  userDataPath = file("${path.module}/userdata/db-installation.sh")
}