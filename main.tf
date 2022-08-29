module "vpc" {
  source = "./modules/VPC"
  vpc = {
    vpcCidr = var.vpc_["vpc_cidr"]
    publicSubnet = var.vpc_["public_subnet"]
    privateSubnet = var.vpc_["private_subnet"]
  }
  name = local.prefix
}

module "IAM" {
  source = "./modules/IAM"
  roleName = var.role_name
  policyPath = file("${path.module}/polices/ssm.json")
}

module "lb-Sg" {
  source = "./modules/SecurityGroup"
  vpcId = module.vpc.vpcId_out
  ingressTraffic = var.lb_IngressTraffic
  protocol = "tcp"
  prefix = "ALB"

  name = local.prefix
}

module "db-sg" {
  source = "./modules/SecurityGroup"
  vpcId = module.vpc.vpcId_out
  ingressTraffic = var.db_IngressTraffic
  protocol = "tcp"
  prefix = "DB"

  name = local.prefix
}

module "web-sg" {
  source = "./modules/SecurityGroup"
  vpcId = module.vpc.vpcId_out
  ingressTraffic = var.web_IngressTraffic
  protocol = "tcp"
  prefix = "web"

  name = local.prefix
}