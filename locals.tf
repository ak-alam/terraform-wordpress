locals {
  prefix = "${var.name}-${terraform.workspace}"
}
locals {
  nlb = {for k, v in var.tg_settings : k => v if contains(values(v), "NLB")}
  alb = {for k, v in var.tg_settings : k => v if contains(values(v), "ALB")}
}