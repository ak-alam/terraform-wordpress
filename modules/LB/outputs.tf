output "lb_dns" {
  description = "NLB DNS name"  
  value = aws_lb.loadbalancer.dns_name
}

output "target_arns" {
  value = aws_lb_target_group.lb_TragetGroup.arn
}