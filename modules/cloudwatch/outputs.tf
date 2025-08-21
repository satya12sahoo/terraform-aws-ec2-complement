# =============================================================================
# CLOUDWATCH MODULE OUTPUTS
# =============================================================================

# CloudWatch Log Group
output "log_group" {
  description = "CloudWatch log group created for instance"
  value = var.create_log_group ? aws_cloudwatch_log_group.instance_logs[0] : null
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value = var.create_log_group ? aws_cloudwatch_log_group.instance_logs[0].name : null
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value = var.create_log_group ? aws_cloudwatch_log_group.instance_logs[0].arn : null
}

# EventBridge Rule
output "scheduling_rule" {
  description = "EventBridge rule created for instance scheduling"
  value = var.enable_scheduling ? aws_cloudwatch_event_rule.instance_schedule[0] : null
}

output "scheduling_rule_name" {
  description = "Name of the EventBridge rule"
  value = var.enable_scheduling ? aws_cloudwatch_event_rule.instance_schedule[0].name : null
}

output "scheduling_rule_arn" {
  description = "ARN of the EventBridge rule"
  value = var.enable_scheduling ? aws_cloudwatch_event_rule.instance_schedule[0].arn : null
}

# EventBridge Target
output "scheduling_target" {
  description = "EventBridge target created for instance scheduling"
  value = var.enable_scheduling ? aws_cloudwatch_event_target.instance_start[0] : null
}

# IAM Role
output "eventbridge_role" {
  description = "IAM role for EventBridge"
  value = var.enable_scheduling ? aws_iam_role.eventbridge_role[0] : null
}

output "eventbridge_role_arn" {
  description = "ARN of the IAM role for EventBridge"
  value = var.enable_scheduling ? aws_iam_role.eventbridge_role[0].arn : null
}
