resource "aws_instance" "instance" {
  ami = var.ami
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = var.security_groups
  subnet_id = var.subnet_Id
  iam_instance_profile = var.instance_profile
  user_data = var.user_data_path
  tags = {
    "Name" = "${var.prefix}-server"
  }
}