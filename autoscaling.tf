# Auto Scaling Group Resources

# Create Auto Scaling Groups
resource "aws_autoscaling_group" "instance_asg" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_auto_scaling_group && v.asg_config != null
  }

  name_prefix = "${each.value.name}-asg-"
  max_size    = each.value.asg_config.max_size
  min_size    = each.value.asg_config.min_size
  desired_capacity = each.value.asg_config.desired_capacity

  health_check_type         = each.value.asg_config.health_check_type
  health_check_grace_period = each.value.asg_config.health_check_grace_period
  default_cooldown          = each.value.asg_config.cooldown

  vpc_zone_identifier = [each.value.subnet_id]

  target_group_arns = each.value.enable_load_balancer && each.value.load_balancer_config != null ? [each.value.load_balancer_config.target_group_arn] : []

  protect_from_scale_in = each.value.asg_config.enable_scale_in_protection

  tag {
    key                 = "Name"
    value               = each.value.name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = each.value.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
