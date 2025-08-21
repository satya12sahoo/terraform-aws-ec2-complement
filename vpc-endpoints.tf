# VPC Endpoint Resources

# Create VPC Endpoints
resource "aws_vpc_endpoint" "service_endpoints" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_vpc_endpoints && v.subnet_id != null
  }

  vpc_id            = data.aws_subnet.vpc_endpoint_subnet[each.key].vpc_id
  service_name      = each.value.vpc_endpoints[0]  # Use first endpoint for now
  vpc_endpoint_type = "Interface"

  subnet_ids = [data.aws_subnet.vpc_endpoint_subnet[each.key].id]

  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint[each.key].id]

  tags = merge(
    each.value.tags,
    {
      Name = "${each.value.name}-vpc-endpoint"
      Purpose = "VPC endpoint for ${each.value.name}"
    }
  )
}

# Security group for VPC endpoints
resource "aws_security_group" "vpc_endpoint" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_vpc_endpoints && v.subnet_id != null
  }

  name_prefix = "${each.value.name}-vpc-endpoint-"
  vpc_id      = data.aws_subnet.vpc_endpoint_subnet[each.key].vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    each.value.tags,
    {
      Name = "${each.value.name}-vpc-endpoint-sg"
      Purpose = "VPC endpoint security group"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
