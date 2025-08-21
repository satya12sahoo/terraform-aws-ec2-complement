# =============================================================================
# CLOUDWATCH MODULE VARIABLES
# =============================================================================

variable "create_log_group" {
  description = "Whether to create a CloudWatch log group"
  type = bool
  default = false
}

variable "log_group_name" {
  description = "Name for the CloudWatch log group"
  type = string
  default = null
}

variable "log_retention_days" {
  description = "Log retention period in days"
  type = number
  default = 30
}

variable "enable_scheduling" {
  description = "Whether to enable instance scheduling"
  type = bool
  default = false
}

variable "instance_name" {
  description = "Name of the instance for scheduling"
  type = string
  default = null
}

variable "schedule_rule_name" {
  description = "Name for the EventBridge schedule rule"
  type = string
  default = null
}

variable "schedule_expression" {
  description = "Cron expression for scheduling"
  type = string
  default = "cron(0 8 ? * MON-FRI *)"
}

variable "eventbridge_role_name" {
  description = "Name for the EventBridge IAM role"
  type = string
  default = null
}

variable "eventbridge_policy_name" {
  description = "Name for the EventBridge IAM policy"
  type = string
  default = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}

# Additional user-configurable options
variable "log_group_kms_key_id" {
  description = "KMS key ID for log group encryption"
  type = string
  default = null
}

variable "log_group_skip_destroy" {
  description = "Whether to skip destroying the log group on terraform destroy"
  type = bool
  default = false
}

variable "schedule_timezone" {
  description = "Timezone for the schedule (e.g., UTC, America/New_York)"
  type = string
  default = "UTC"
}

variable "schedule_description" {
  description = "Description for the EventBridge schedule rule"
  type = string
  default = "Schedule for EC2 instance start/stop"
}

variable "eventbridge_role_description" {
  description = "Description for the EventBridge IAM role"
  type = string
  default = "IAM role for EventBridge to manage EC2 instances"
}

variable "eventbridge_policy_description" {
  description = "Description for the EventBridge IAM policy"
  type = string
  default = "Policy allowing EventBridge to start/stop EC2 instances"
}

variable "enable_stop_schedule" {
  description = "Whether to enable stop schedule in addition to start schedule"
  type = bool
  default = false
}

variable "stop_schedule_expression" {
  description = "Cron expression for stop scheduling"
  type = string
  default = "cron(0 18 ? * MON-FRI *)"
}

variable "schedule_target_arn" {
  description = "Custom ARN for the EventBridge target (defaults to EC2 start/stop automation)"
  type = string
  default = null
}
