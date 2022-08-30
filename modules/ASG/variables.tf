variable "prefix" {
  type = string
  # default="akbar-asg"
}
variable "postfix" {
  type = string
}
variable "name"{
  type = string
}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "health_check_grace_period" {}

variable "vpc_id" {
    # type = list(string)
}

variable "target_group_arns" {
  type = list(string)
}
variable "template_id" {}

variable "email" {
  type = string
  default = "akbar.alam@eurustechnologies.com"
}

variable "step_adjustments_up" {
    type = map
    default = {
      0 = [ 0.0, 10.0 ]
      10 = [ 10.0, 20.0 ]
      30 = [ 20 , null ]
    }
  
}

variable "step_adjustments_down" {
    type = map
    default = {
        0 = [ -10.0 , 0.0 ]
      -10 = [ -20.0, -10.0 ]
      -30 = [ null , -20.0 ]
    }  
}

variable "ASG_Autoscaling_policy" {
  type = object({
    adjustment_type = string
    policy_type = string
    metric_aggregation_type = string
  })
  default = {
    adjustment_type = "PercentChangeInCapacity"
    metric_aggregation_type = "Maximum"
    policy_type = "StepScaling"
  }
}
variable "CW_alarm_high" {
    type = object({
        comparison_operator = string
        evaluation_periods  = string
        metric_name         = string
        namespace           = string
        period              = string
        statistic           = string
        threshold           = string
    })
    default = {
        comparison_operator = "GreaterThanOrEqualToThreshold"
        evaluation_periods  = "1"
        metric_name         = "CPUUtilization"
        namespace           = "AWS/EC2"
        period              = "60"
        statistic           = "Maximum"
        threshold           = "70"
    }
  
}

variable "CW_alarm_low" {
    type = object({
        comparison_operator = string
        evaluation_periods  = string
        metric_name         = string
        namespace           = string
        period              = string
        statistic           = string
        threshold           = string
    })
    default = {
        comparison_operator = "LessThanOrEqualToThreshold"
        evaluation_periods  = "1"
        metric_name         = "CPUUtilization"
        namespace           = "AWS/EC2"
        period              = "60"
        statistic           = "Maximum"
        threshold           = "20"
    }
  
}