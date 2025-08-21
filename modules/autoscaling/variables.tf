# =============================================================================
# AUTO SCALING MODULE VARIABLES
# =============================================================================

variable "create_auto_scaling_group" {
  description = "Whether to create an auto scaling group"
  type = bool
  default = false
}

variable "subnet_id" {
  description = "Subnet ID for the auto scaling group"
  type = string
  default = null
}

variable "asg_name" {
  description = "Name for the auto scaling group"
  type = string
  default = null
}

variable "min_size" {
  description = "Minimum size of the auto scaling group"
  type = number
  default = 1
}

variable "max_size" {
  description = "Maximum size of the auto scaling group"
  type = number
  default = 3
}

variable "desired_capacity" {
  description = "Desired capacity of the auto scaling group"
  type = number
  default = 1
}

variable "health_check_type" {
  description = "Health check type for the auto scaling group"
  type = string
  default = "EC2"
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type = number
  default = 300
}

variable "cooldown" {
  description = "Cooldown period in seconds"
  type = number
  default = 300
}

variable "enable_scale_in_protection" {
  description = "Whether to enable scale in protection"
  type = bool
  default = false
}

variable "launch_template_name" {
  description = "Name of the launch template"
  type = string
  default = null
}

variable "scale_out_policy_name" {
  description = "Name for the scale out policy"
  type = string
  default = null
}

variable "scale_in_policy_name" {
  description = "Name for the scale in policy"
  type = string
  default = null
}

variable "scale_out_alarm_name" {
  description = "Name for the scale out alarm"
  type = string
  default = null
}

variable "scale_in_alarm_name" {
  description = "Name for the scale in alarm"
  type = string
  default = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}

# Additional user-configurable options
variable "asg_description" {
  description = "Description for the auto scaling group"
  type = string
  default = "Auto Scaling Group for EC2 instances"
}

variable "launch_template_version" {
  description = "Version of the launch template to use"
  type = string
  default = "$Latest"
}

variable "mixed_instances_policy" {
  description = "Mixed instances policy configuration"
  type = object({
    instances_distribution = optional(object({
      on_demand_base_capacity = optional(number, 0)
      on_demand_percentage_above_base_capacity = optional(number, 100)
      spot_allocation_strategy = optional(string, "lowest-price")
      spot_instance_pools = optional(number, 2)
    }))
    override = optional(list(object({
      instance_type = string
      weighted_capacity = optional(string)
    })), [])
  })
  default = null
}

variable "scale_out_adjustment" {
  description = "Number of instances to add when scaling out"
  type = number
  default = 1
}

variable "scale_in_adjustment" {
  description = "Number of instances to remove when scaling in"
  type = number
  default = -1
}

variable "scale_out_threshold" {
  description = "CPU threshold percentage for scale out alarm"
  type = number
  default = 80
}

variable "scale_in_threshold" {
  description = "CPU threshold percentage for scale in alarm"
  type = number
  default = 40
}

variable "alarm_evaluation_periods" {
  description = "Number of evaluation periods for alarms"
  type = number
  default = 2
}

variable "alarm_period" {
  description = "Period in seconds for alarm evaluation"
  type = number
  default = 120
}

variable "alarm_statistic" {
  description = "Statistic for alarm evaluation (Average, Minimum, Maximum, Sum, SampleCount)"
  type = string
  default = "Average"
}

variable "alarm_namespace" {
  description = "CloudWatch namespace for alarms"
  type = string
  default = "AWS/EC2"
}

variable "alarm_metric_name" {
  description = "CloudWatch metric name for alarms"
  type = string
  default = "CPUUtilization"
}

variable "scale_out_alarm_description" {
  description = "Description for the scale out alarm"
  type = string
  default = "Scale out if CPU > 80% for 4 minutes"
}

variable "scale_in_alarm_description" {
  description = "Description for the scale in alarm"
  type = string
  default = "Scale in if CPU < 40% for 4 minutes"
}

variable "enable_instance_refresh" {
  description = "Whether to enable instance refresh"
  type = bool
  default = false
}

variable "instance_refresh_strategy" {
  description = "Strategy for instance refresh (Rolling, RollingWithPercentage)"
  type = string
  default = "Rolling"
}

variable "instance_refresh_min_healthy_percentage" {
  description = "Minimum healthy percentage during instance refresh"
  type = number
  default = 50
}

variable "enable_metrics_collection" {
  description = "Whether to enable detailed monitoring metrics collection"
  type = bool
  default = true
}

variable "metrics_granularity" {
  description = "Granularity of metrics collection (1Minute, 5Minute)"
  type = string
  default = "1Minute"
}

variable "suspended_processes" {
  description = "List of processes to suspend in the auto scaling group"
  type = list(string)
  default = []
}
