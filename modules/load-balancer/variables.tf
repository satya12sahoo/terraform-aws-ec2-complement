# =============================================================================
# LOAD BALANCER MODULE VARIABLES
# =============================================================================

variable "create_load_balancer" {
  description = "Whether to create a load balancer"
  type = bool
  default = false
}

variable "subnet_id" {
  description = "Subnet ID for the load balancer"
  type = string
  default = null
}

variable "security_group_name" {
  description = "Name for the load balancer security group"
  type = string
  default = null
}

variable "target_group_name" {
  description = "Name for the target group"
  type = string
  default = null
}

variable "target_group_port" {
  description = "Port for the target group"
  type = number
  default = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type = string
  default = "HTTP"
}

variable "health_check_path" {
  description = "Health check path"
  type = string
  default = "/"
}

variable "health_check_port" {
  description = "Health check port"
  type = number
  default = 80
}

variable "health_check_protocol" {
  description = "Health check protocol"
  type = string
  default = "HTTP"
}

variable "load_balancer_name" {
  description = "Name for the load balancer"
  type = string
  default = null
}

variable "load_balancer_internal" {
  description = "Whether the load balancer is internal"
  type = bool
  default = false
}

variable "listener_port" {
  description = "Port for the listener"
  type = number
  default = 80
}

variable "listener_protocol" {
  description = "Protocol for the listener"
  type = string
  default = "HTTP"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}

# Additional user-configurable options
variable "load_balancer_type" {
  description = "Type of load balancer (application, network, gateway)"
  type = string
  default = "application"
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the load balancer"
  type = bool
  default = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Whether to enable cross-zone load balancing"
  type = bool
  default = true
}

variable "idle_timeout" {
  description = "Idle timeout in seconds"
  type = number
  default = 60
}

variable "security_group_description" {
  description = "Description for the load balancer security group"
  type = string
  default = "Security group for Application Load Balancer"
}

variable "security_group_rules" {
  description = "Custom security group rules for the load balancer"
  type = list(object({
    type = string
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      type = "ingress"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      type = "ingress"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    },
    {
      type = "egress"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound traffic"
    }
  ]
}

variable "target_group_target_type" {
  description = "Target type for the target group (instance, ip, lambda, alb)"
  type = string
  default = "instance"
}

variable "health_check_enabled" {
  description = "Whether to enable health checks"
  type = bool
  default = true
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type = number
  default = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type = number
  default = 5
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive health checks required for healthy"
  type = number
  default = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive health checks required for unhealthy"
  type = number
  default = 2
}

variable "health_check_matcher" {
  description = "HTTP codes to use when checking for a successful response"
  type = string
  default = "200"
}

variable "listener_default_action_type" {
  description = "Default action type for the listener (forward, redirect, fixed-response)"
  type = string
  default = "forward"
}

variable "load_balancer_description" {
  description = "Description for the load balancer"
  type = string
  default = "Application Load Balancer for EC2 instances"
}

variable "target_group_description" {
  description = "Description for the target group"
  type = string
  default = "Target group for EC2 instances"
}
