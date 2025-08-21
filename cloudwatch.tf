# CloudWatch Resources

# Create CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "instance_logs" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_cloudwatch_agent && v.cloudwatch_agent_config != null && v.cloudwatch_agent_config.create_log_group
  }

  name              = coalesce(each.value.cloudwatch_agent_config.log_group_name, "/aws/ec2/${each.value.name}")
  retention_in_days = each.value.cloudwatch_agent_config.log_retention_days

  tags = merge(
    each.value.tags,
    {
      Name = coalesce(each.value.cloudwatch_agent_config.log_group_name, "/aws/ec2/${each.value.name}")
      Purpose = "EC2 instance logs"
    }
  )
}

# Create EventBridge Rules for Scheduling
resource "aws_cloudwatch_event_rule" "instance_schedule" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_scheduling && v.schedule_config != null
  }

  name_prefix = "${each.value.name}-schedule-"
  description = "Schedule for ${each.value.name} instance"

  schedule_expression = "cron(0 ${each.value.schedule_config.start_time} ? * ${join(",", each.value.schedule_config.days_of_week)} *)"

  tags = merge(
    each.value.tags,
    {
      Name = "${each.value.name}-schedule-rule"
      Purpose = "Instance scheduling"
    }
  )
}

# Create EventBridge Targets for Start/Stop
resource "aws_cloudwatch_event_target" "instance_start" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_scheduling && v.schedule_config != null
  }

  rule      = aws_cloudwatch_event_rule.instance_schedule[each.key].name
  target_id = "${each.value.name}-start"
  arn       = "arn:aws:automation:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:automation-definition/AWS-StartEC2Instance"

  input = jsonencode({
    InstanceId = [module.ec2_instance[each.key].id]
  })
}
