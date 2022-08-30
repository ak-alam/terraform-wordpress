data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [ var.vpc_id ]
  }

  tags = {
    Tier = "Private"
  }
}


resource "aws_autoscaling_group" "asg" {
  name = "${var.prefix}-ASG"
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type = "ELB"
  vpc_zone_identifier = data.aws_subnets.private.ids
  target_group_arns = var.target_group_arns
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = var.template_id
      }
    }
  }
  tag {
    key = "Name"
    value = "${var.name}"
    propagate_at_launch = true
  }

}
resource "aws_autoscaling_notification" "notifications" {
  group_names = [
    aws_autoscaling_group.asg.name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.topic.arn
}

resource "aws_sns_topic" "topic" {
  name = "${var.name}-${var.postfix}-topic"
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_autoscaling_policy" "scale_up" {

  name                   = "${var.name}-${var.postfix}-up"
  autoscaling_group_name = aws_autoscaling_group.asg.name

  adjustment_type           = var.ASG_Autoscaling_policy[ "adjustment_type" ]
  policy_type               = var.ASG_Autoscaling_policy[ "policy_type" ]
  metric_aggregation_type   = var.ASG_Autoscaling_policy[ "metric_aggregation_type" ]

  dynamic step_adjustment {
    for_each = var.step_adjustments_up
    content{
    scaling_adjustment          = step_adjustment.key
    metric_interval_lower_bound = step_adjustment.value[0]
    metric_interval_upper_bound = step_adjustment.value[1]
    }
  }

}

resource "aws_autoscaling_policy" "scale_down" {

  name                   = "${var.name}-${var.postfix}-down"
  autoscaling_group_name = aws_autoscaling_group.asg.name

  adjustment_type           = var.ASG_Autoscaling_policy[ "adjustment_type" ]
  policy_type               = var.ASG_Autoscaling_policy[ "policy_type" ]
  metric_aggregation_type   = var.ASG_Autoscaling_policy[ "metric_aggregation_type" ]

  dynamic step_adjustment {
    for_each = var.step_adjustments_down
    content{
    scaling_adjustment          = step_adjustment.key
    metric_interval_lower_bound = step_adjustment.value[0]
    metric_interval_upper_bound = step_adjustment.value[1]
    }
  }

}

resource "aws_cloudwatch_metric_alarm" "High" {
  alarm_name          = "${var.name}-${var.postfix}-high"
  comparison_operator = var.CW_alarm_high[ "comparison_operator" ]
  evaluation_periods  = var.CW_alarm_high[ "evaluation_periods" ]
  metric_name         = var.CW_alarm_high[ "metric_name" ]
  namespace           = var.CW_alarm_high[ "namespace" ]
  period              = var.CW_alarm_high[ "period" ]
  statistic           = var.CW_alarm_high[ "statistic" ]
  threshold           = var.CW_alarm_high[ "threshold" ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "default metric monitors ec2 cpu utilization Scale out if CPU > 60% for 2 minutes"
  alarm_actions     = [ aws_autoscaling_policy.scale_up.arn ]
}



resource "aws_cloudwatch_metric_alarm" "low" {
  alarm_name          = "${var.name}-${var.postfix}-low"
  comparison_operator = var.CW_alarm_low[ "comparison_operator" ]
  evaluation_periods  = var.CW_alarm_low[ "evaluation_periods" ]
  metric_name         = var.CW_alarm_low[ "metric_name" ]
  namespace           = var.CW_alarm_low[ "namespace" ]
  period              = var.CW_alarm_low[ "period" ]
  statistic           = var.CW_alarm_low[ "statistic" ]
  threshold           = var.CW_alarm_low[ "threshold" ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "default metric monitors ec2 cpu utilization Scale in if CPU < 40% for 2 minutes"
  alarm_actions     = [ aws_autoscaling_policy.scale_down.arn ]
}
