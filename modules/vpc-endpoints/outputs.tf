# =============================================================================
# VPC ENDPOINTS MODULE OUTPUTS
# =============================================================================

# VPC Endpoint
output "vpc_endpoint" {
  description = "VPC endpoint created for instance"
  value = var.create_vpc_endpoint ? aws_vpc_endpoint.service_endpoint[0] : null
}

output "vpc_endpoint_id" {
  description = "ID of the VPC endpoint"
  value = var.create_vpc_endpoint ? aws_vpc_endpoint.service_endpoint[0].id : null
}

output "vpc_endpoint_arn" {
  description = "ARN of the VPC endpoint"
  value = var.create_vpc_endpoint ? aws_vpc_endpoint.service_endpoint[0].arn : null
}

# Security Group
output "vpc_endpoint_security_group" {
  description = "VPC endpoint security group created for instance"
  value = var.create_vpc_endpoint ? aws_security_group.vpc_endpoint[0] : null
}

output "vpc_endpoint_security_group_id" {
  description = "ID of the VPC endpoint security group"
  value = var.create_vpc_endpoint ? aws_security_group.vpc_endpoint[0].id : null
}
