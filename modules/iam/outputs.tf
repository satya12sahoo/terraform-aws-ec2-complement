# =============================================================================
# IAM MODULE OUTPUTS
# =============================================================================

output "instance_profile" {
  description = "Instance profile created for existing IAM role"
  value = var.create_instance_profile ? aws_iam_instance_profile.existing_role_profile[0] : null
}

output "instance_profile_name" {
  description = "Name of the instance profile created for existing IAM role"
  value = var.create_instance_profile ? aws_iam_instance_profile.existing_role_profile[0].name : null
}

output "instance_profile_arn" {
  description = "ARN of the instance profile created for existing IAM role"
  value = var.create_instance_profile ? aws_iam_instance_profile.existing_role_profile[0].arn : null
}
