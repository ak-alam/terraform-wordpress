resource "aws_security_group" "securityGroup" {
#   name = "${var.name}-sg"
  description = "security group"
  vpc_id = var.vpcId
  
  dynamic "ingress" {
    for_each = var.ingressTraffic #[80, 3306]
    content {
    description = "Allow Internet Traffic"
    from_port = ingress.key
    to_port = ingress.key
    protocol = var.protocol
    cidr_blocks = ingress.value
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}-sg"
  }
}