# =============================================================================
# AUTO SCALING MODULE OUTPUTS
# =============================================================================

# Auto Scaling Group
output "autoscaling_group" {
  description = "Auto Scaling group created for instance"
  value = var.create_auto_scaling_group ? aws_autoscaling_group.instance_asg[0] : null
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling group"
  value = var.create_auto_scaling_group ? aws_autoscaling_group.instance_asg[0].name : null
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling group"
  value = var.create_auto_scaling_group ? aws_autoscaling_group.instance_asg[0].arn : null
}

# Auto Scaling Policies
output "scale_out_policy" {
  description = "Scale out policy"
  value = var.create_auto_scaling_group ? aws_autoscaling_policy.scale_out[0] : null
}

output "scale_in_policy" {
  description = "Scale in policy"
  value = var.create_auto_scaling_group ? aws_autoscaling_policy.scale_in[0] : null
}

# CloudWatch Alarms
output "scale_out_alarm" {
  description = "Scale out alarm"
  value = var.create_auto_scaling_group ? aws_cloudwatch_metric_alarm.scale_out_alarm[0] : null
}

output "scale_in_alarm" {
  description = "Scale in alarm"
  value = var.create_auto_scaling_group ? aws_cloudwatch_metric_alarm.scale_in_alarm[0] : null
}
