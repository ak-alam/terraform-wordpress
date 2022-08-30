#1. Load balancer
#2. Target group
#3. Listener
#4.Target group attachment

resource "aws_lb" "loadbalancer" {
  name = "${var.prefix}-lb"
  internal = var.internal
  load_balancer_type = var.type
  security_groups = var.security_groups
  subnets = var.subne_Ids
  tags = {
    Name = "${var.prefix}-lb"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  protocol = var.tg_vars.protocol
  port = var.tg_vars.port
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_TragetGroup.arn
  }
}

resource "aws_lb_target_group" "lb_TragetGroup" {
    name = "${var.prefix}-tg"
    protocol = var.tg_vars.protocol
    port = var.tg_vars.port
    vpc_id = var.vpc_Id
    deregistration_delay = var.deregistration_delay
    health_check {
        interval            = var.tg_vars.HC_interval
        path                = var.tg_vars.path == -1 ? null : var.tg_vars.path
        healthy_threshold   = var.tg_vars.HC_healthy_threshold
        unhealthy_threshold = var.tg_vars.HC_unhealthy_threshold
        timeout             = var.tg_vars.HC_timeout == -1 ? null : var.tg_vars.HC_timeout
        protocol            = var.tg_vars.protocol
    }
    tags = {
      Name = "${var.prefix}-tg"
    }
}

resource "aws_lb_target_group_attachment" "lbTargetGroupAttachment" {
  count = length(var.target_instance) != 0 ? 1 : 0  
  target_group_arn = aws_lb_target_group.lb_TragetGroup.arn
  target_id = var.target_instance
  port = var.tg_vars.port
}