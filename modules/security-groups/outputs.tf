# =============================================================================
# SECURITY GROUPS MODULE OUTPUTS
# =============================================================================

# Security Group
output "instance_security_group" {
  description = "Security group created for instance"
  value = var.create_security_group ? aws_security_group.instance_sg[0] : null
}

output "instance_security_group_id" {
  description = "ID of the security group"
  value = var.create_security_group ? aws_security_group.instance_sg[0].id : null
}

output "instance_security_group_name" {
  description = "Name of the security group"
  value = var.create_security_group ? aws_security_group.instance_sg[0].name : null
}
