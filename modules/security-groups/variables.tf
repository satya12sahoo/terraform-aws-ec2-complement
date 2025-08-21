# =============================================================================
# SECURITY GROUPS MODULE VARIABLES
# =============================================================================

variable "create_security_group" {
  description = "Whether to create a security group"
  type = bool
  default = true
}

variable "subnet_id" {
  description = "Subnet ID for the security group"
  type = string
  default = null
}

variable "security_group_name" {
  description = "Name for the security group"
  type = string
  default = null
}

variable "security_group_description" {
  description = "Description for the security group"
  type = string
  default = "Security group for instance"
}

variable "security_group_tags" {
  description = "Additional tags for the security group"
  type = map(string)
  default = {}
}

variable "security_group_egress_rules" {
  description = "Egress rules for the security group"
  type = map(object({
    cidr_ipv4 = optional(string)
    cidr_ipv6 = optional(string)
    description = optional(string)
    from_port = optional(number)
    ip_protocol = optional(string, "tcp")
    prefix_list_id = optional(string)
    referenced_security_group_id = optional(string)
    tags = optional(map(string), {})
    to_port = optional(number)
  }))
  default = {}
}

variable "security_group_ingress_rules" {
  description = "Ingress rules for the security group"
  type = map(object({
    cidr_ipv4 = optional(string)
    cidr_ipv6 = optional(string)
    description = optional(string)
    from_port = optional(number)
    ip_protocol = optional(string, "tcp")
    prefix_list_id = optional(string)
    referenced_security_group_id = optional(string)
    tags = optional(map(string), {})
    to_port = optional(number)
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}

# Additional user-configurable options
variable "vpc_id" {
  description = "VPC ID for the security group (if not using subnet_id)"
  type = string
  default = null
}

variable "security_group_revoke_rules_on_delete" {
  description = "Whether to revoke rules on delete"
  type = bool
  default = false
}

variable "default_egress_rule" {
  description = "Default egress rule configuration"
  type = object({
    enabled = optional(bool, true)
    from_port = optional(number, 0)
    to_port = optional(number, 0)
    protocol = optional(string, "-1")
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
    ipv6_cidr_blocks = optional(list(string), ["::/0"])
    description = optional(string, "Allow all outbound traffic")
  })
  default = {
    enabled = true
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Allow all outbound traffic"
  }
}

variable "common_ingress_rules" {
  description = "Common ingress rules to add by default"
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    }
  ]
}

variable "enable_common_ingress_rules" {
  description = "Whether to enable common ingress rules"
  type = bool
  default = true
}

variable "security_group_name_prefix" {
  description = "Prefix for security group name if name is not provided"
  type = string
  default = null
}

variable "security_group_use_name_prefix" {
  description = "Whether to use name prefix for security group naming"
  type = bool
  default = false
}
