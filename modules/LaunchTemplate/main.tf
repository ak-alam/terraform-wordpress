data "template_file" userdatamodule {
  template = "${file(var.user_data)}"
  vars = {
    DB_HOST = var.DB_HOST
  }
}    
resource "aws_launch_template" "ASGLuanchTemp" {
  name = "${var.name}-${var.prefix}-template"
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.security_groups
  iam_instance_profile {
    name = var.instance_profile
  }
  user_data = base64encode("${data.template_file.userdatamodule.rendered}")
  monitoring {
    enabled = true
  }
  tags = {
    "Name" = "${var.prefix}"
  }
}
