#1. Load balancer
#2. Target group
#3. Listener
#4.Target group attachment

resource "aws_lb" "loadbalancer" {
#   name = "${var.name}-lb"
  internal = var.lbSchema
  load_balancer_type = var.lbType
  security_groups = var.securityGroups
  subnets = var.subneIds
  tags = {
    Name = "${terraform.workspace}-lb"
  }
}

resource "aws_lb_listener" "LBlistener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  protocol = var.protocol
  port = var.port
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.LBTragetGroup.arn
  }
}

resource "aws_lb_target_group" "LBTragetGroup" {
    # name = 
    port = var.port
    protocol = var.protocol
    vpc_id = var.vpcId
    deregistration_delay = var.deregistrationDelay
    health_check {
        protocol = var.protocol
        port = var.port
        path = var.path
        healthy_threshold = var.healthyThreshold
    }
}

resource "aws_lb_target_group_attachment" "lbTargetGroupAttachment" {
  count = length(var.targetInstance) != 0 ? 1 : 0  
  target_group_arn = aws_lb_target_group.LBTragetGroup.arn
  target_id = var.targetInstance
  port = var.port
}