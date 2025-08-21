# =============================================================================
# IAM MODULE VARIABLES
# =============================================================================

variable "create_instance_profile" {
  description = "Whether to create an instance profile for existing IAM role"
  type = bool
  default = false
}

variable "iam_role_name" {
  description = "Name of the existing IAM role to attach to the instance profile"
  type = string
  default = null
}

variable "instance_profile_name" {
  description = "Name for the instance profile"
  type = string
  default = null
}

variable "instance_profile_path" {
  description = "Path for the instance profile"
  type = string
  default = "/"
}

variable "instance_profile_tags" {
  description = "Additional tags for the instance profile"
  type = map(string)
  default = {}
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}

# Additional user-configurable options
variable "instance_profile_description" {
  description = "Description for the instance profile"
  type = string
  default = "Instance profile for EC2 instances"
}

variable "enable_instance_profile_rotation" {
  description = "Whether to enable instance profile rotation (for future use)"
  type = bool
  default = false
}

variable "instance_profile_permissions_boundary" {
  description = "ARN of the permissions boundary to attach to the instance profile"
  type = string
  default = null
}
