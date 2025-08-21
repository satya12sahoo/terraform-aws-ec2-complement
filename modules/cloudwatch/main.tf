# =============================================================================
# CLOUDWATCH MODULE - Log Group and EventBridge Resources
# =============================================================================

# CloudWatch Log Group for instance
resource "aws_cloudwatch_log_group" "instance_logs" {
  count = var.create_log_group ? 1 : 0

  name = var.log_group_name
  retention_in_days = var.log_retention_days
  kms_key_id = var.log_group_kms_key_id
  skip_destroy = var.log_group_skip_destroy

  tags = merge(
    var.common_tags,
    {
      Name = var.log_group_name
      Module = "cloudwatch"
      RetentionDays = var.log_retention_days
      Encrypted = var.log_group_kms_key_id != null
    }
  )
}

# EventBridge Rule for instance scheduling
resource "aws_cloudwatch_event_rule" "instance_schedule" {
  count = var.enable_scheduling ? 1 : 0

  name = var.schedule_rule_name
  description = var.schedule_description
  schedule_expression = var.schedule_expression

  tags = merge(
    var.common_tags,
    {
      Name = var.schedule_rule_name
      Module = "cloudwatch"
      Timezone = var.schedule_timezone
      InstanceName = var.instance_name
    }
  )
}

# EventBridge Target for instance start/stop
resource "aws_cloudwatch_event_target" "instance_start" {
  count = var.enable_scheduling ? 1 : 0

  rule = aws_cloudwatch_event_rule.instance_schedule[0].name
  target_id = "${var.instance_name}-start"

  arn = var.schedule_target_arn != null ? var.schedule_target_arn : "arn:aws:automate:${data.aws_region.current.name}:ec2:start"
  role_arn = aws_iam_role.eventbridge_role[0].arn
}

# IAM Role for EventBridge
resource "aws_iam_role" "eventbridge_role" {
  count = var.enable_scheduling ? 1 : 0

  name = var.eventbridge_role_name
  description = var.eventbridge_role_description

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = var.eventbridge_role_name
      Module = "cloudwatch"
      Description = var.eventbridge_role_description
    }
  )
}

# IAM Policy for EventBridge
resource "aws_iam_role_policy" "eventbridge_policy" {
  count = var.enable_scheduling ? 1 : 0

  name = var.eventbridge_policy_name
  role = aws_iam_role.eventbridge_role[0].id
  description = var.eventbridge_policy_description

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Name" = var.instance_name
          }
        }
      }
    ]
  })
}

# Data source for current region
data "aws_region" "current" {}
