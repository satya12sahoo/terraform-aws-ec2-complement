# =============================================================================
# AUTO SCALING MODULE - Auto Scaling Group
# =============================================================================

# Auto Scaling Group
resource "aws_autoscaling_group" "instance_asg" {
  count = var.create_auto_scaling_group ? 1 : 0

  name = var.asg_name
  desired_capacity = var.desired_capacity
  max_size = var.max_size
  min_size = var.min_size

  vpc_zone_identifier = [var.subnet_id]
  health_check_type = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_cooldown = var.cooldown

  # Launch template configuration
  dynamic "mixed_instances_policy" {
    for_each = var.mixed_instances_policy != null ? [var.mixed_instances_policy] : []
    content {
      launch_template {
        launch_template_specification {
          launch_template_name = var.launch_template_name
          version = var.launch_template_version
        }
      }

      dynamic "instances_distribution" {
        for_each = mixed_instances_policy.value.instances_distribution != null ? [mixed_instances_policy.value.instances_distribution] : []
        content {
          on_demand_base_capacity = instances_distribution.value.on_demand_base_capacity
          on_demand_percentage_above_base_capacity = instances_distribution.value.on_demand_percentage_above_base_capacity
          spot_allocation_strategy = instances_distribution.value.spot_allocation_strategy
          spot_instance_pools = instances_distribution.value.spot_instance_pools
        }
      }

      dynamic "override" {
        for_each = mixed_instances_policy.value.override
        content {
          instance_type = override.value.instance_type
          weighted_capacity = override.value.weighted_capacity
        }
      }
    }
  }

  # Simple launch template if no mixed instances policy
  dynamic "launch_template" {
    for_each = var.mixed_instances_policy == null ? [1] : []
    content {
      id = var.launch_template_name
      version = var.launch_template_version
    }
  }

  # Scale in protection
  protect_from_scale_in = var.enable_scale_in_protection

  # Instance refresh
  dynamic "instance_refresh" {
    for_each = var.enable_instance_refresh ? [1] : []
    content {
      strategy = var.instance_refresh_strategy
      min_healthy_percentage = var.instance_refresh_min_healthy_percentage
    }
  }

  # Suspended processes
  dynamic "suspended_processes" {
    for_each = var.suspended_processes
    content {
      name = suspended_processes.value
    }
  }

  # Tags
  tag {
    key = "Name"
    value = var.asg_name
    propagate_at_launch = true
  }

  tag {
    key = "Module"
    value = "autoscaling"
    propagate_at_launch = true
  }

  tag {
    key = "Description"
    value = var.asg_description
    propagate_at_launch = true
  }

  # Add common tags
  dynamic "tag" {
    for_each = var.common_tags
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Policy for scale out
resource "aws_autoscaling_policy" "scale_out" {
  count = var.create_auto_scaling_group ? 1 : 0

  name = var.scale_out_policy_name
  scaling_adjustment = var.scale_out_adjustment
  adjustment_type = "ChangeInCapacity"
  cooldown = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.instance_asg[0].name
}

# Auto Scaling Policy for scale in
resource "aws_autoscaling_policy" "scale_in" {
  count = var.create_auto_scaling_group ? 1 : 0

  name = var.scale_in_policy_name
  scaling_adjustment = var.scale_in_adjustment
  adjustment_type = "ChangeInCapacity"
  cooldown = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.instance_asg[0].name
}

# CloudWatch Alarm for scale out
resource "aws_cloudwatch_metric_alarm" "scale_out_alarm" {
  count = var.create_auto_scaling_group ? 1 : 0

  alarm_name = var.scale_out_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = var.alarm_evaluation_periods
  metric_name = var.alarm_metric_name
  namespace = var.alarm_namespace
  period = var.alarm_period
  statistic = var.alarm_statistic
  threshold = var.scale_out_threshold
  alarm_description = var.scale_out_alarm_description
  alarm_actions = [aws_autoscaling_policy.scale_out[0].arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.instance_asg[0].name
  }
}

# CloudWatch Alarm for scale in
resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
  count = var.create_auto_scaling_group ? 1 : 0

  alarm_name = var.scale_in_alarm_name
  comparison_operator = "LessThanThreshold"
  evaluation_periods = var.alarm_evaluation_periods
  metric_name = var.alarm_metric_name
  namespace = var.alarm_namespace
  period = var.alarm_period
  statistic = var.alarm_statistic
  threshold = var.scale_in_threshold
  alarm_description = var.scale_in_alarm_description
  alarm_actions = [aws_autoscaling_policy.scale_in[0].arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.instance_asg[0].name
  }
}
