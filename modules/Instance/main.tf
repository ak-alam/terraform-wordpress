resource "aws_instance" "instance" {
  ami = var.ami
  key_name = var.keyName
  instance_type = var.instanceType
  vpc_security_group_ids = var.securityGroups
  subnet_id = var.subnetId
  iam_instance_profile = var.IAMInstanceProfile
  user_data = var.userDataPath
}