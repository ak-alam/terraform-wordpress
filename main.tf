module "vpc" {
  source = "./modules/VPC"
  vpc = {
    vpcCidr = var.vpc_["vpc_cidr"]
    publicSubnet = var.vpc_["public_subnet"]
    privateSubnet = var.vpc_["private_subnet"]
  }
  name = local.prefix
}