# =============================================================================
# VPC ENDPOINTS MODULE VARIABLES
# =============================================================================

variable "create_vpc_endpoint" {
  description = "Whether to create a VPC endpoint"
  type = bool
  default = false
}

variable "subnet_id" {
  description = "Subnet ID for the VPC endpoint"
  type = string
  default = null
}

variable "service_name" {
  description = "AWS service name for the VPC endpoint"
  type = string
  default = "com.amazonaws.region.ec2"
}

variable "security_group_name" {
  description = "Name for the VPC endpoint security group"
  type = string
  default = null
}

variable "endpoint_name" {
  description = "Name for the VPC endpoint"
  type = string
  default = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}

# Additional user-configurable options
variable "vpc_endpoint_type" {
  description = "Type of VPC endpoint (Interface, Gateway, GatewayLoadBalancer)"
  type = string
  default = "Interface"
}

variable "private_dns_enabled" {
  description = "Whether to enable private DNS for the VPC endpoint"
  type = bool
  default = true
}

variable "policy" {
  description = "Policy document for the VPC endpoint"
  type = string
  default = null
}

variable "security_group_description" {
  description = "Description for the VPC endpoint security group"
  type = string
  default = "Security group for VPC endpoint"
}

variable "security_group_rules" {
  description = "Custom security group rules for the VPC endpoint"
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
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access for VPC endpoints"
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

variable "endpoint_description" {
  description = "Description for the VPC endpoint"
  type = string
  default = "VPC endpoint for AWS services"
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames for the VPC endpoint"
  type = bool
  default = false
}
