# =============================================================================
# VPC ENDPOINTS MODULE - VPC Endpoint and Security Group
# =============================================================================

# Security Group for VPC Endpoint
resource "aws_security_group" "vpc_endpoint" {
  count = var.create_vpc_endpoint ? 1 : 0

  name = var.security_group_name
  description = var.security_group_description
  vpc_id = data.aws_subnet.vpc_endpoint_subnet.vpc_id

  # Dynamic security group rules
  dynamic "ingress" {
    for_each = [for rule in var.security_group_rules : rule if rule.type == "ingress"]
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = [for rule in var.security_group_rules : rule if rule.type == "egress"]
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.security_group_name
      Module = "vpc-endpoints"
      Description = var.security_group_description
    }
  )
}

# VPC Endpoint for AWS Service
resource "aws_vpc_endpoint" "service_endpoint" {
  count = var.create_vpc_endpoint ? 1 : 0

  vpc_id = data.aws_subnet.vpc_endpoint_subnet.vpc_id
  service_name = var.service_name
  vpc_endpoint_type = var.vpc_endpoint_type
  subnet_ids = [var.subnet_id]
  security_group_ids = [aws_security_group.vpc_endpoint[0].id]
  private_dns_enabled = var.private_dns_enabled
  policy = var.policy

  tags = merge(
    var.common_tags,
    {
      Name = var.endpoint_name
      Module = "vpc-endpoints"
      Description = var.endpoint_description
      ServiceName = var.service_name
      EndpointType = var.vpc_endpoint_type
    }
  )
}

# Data source for VPC endpoint subnet
data "aws_subnet" "vpc_endpoint_subnet" {
  id = var.subnet_id
}
