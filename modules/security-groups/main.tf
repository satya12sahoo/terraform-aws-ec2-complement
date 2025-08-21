# =============================================================================
# SECURITY GROUPS MODULE - Instance Security Group
# =============================================================================

# Security Group for instance
resource "aws_security_group" "instance_sg" {
  count = var.create_security_group ? 1 : 0

  name = var.security_group_name
  name_prefix = var.security_group_name_prefix
  description = var.security_group_description
  vpc_id = var.vpc_id != null ? var.vpc_id : data.aws_subnet.instance_subnet.vpc_id
  revoke_rules_on_delete = var.security_group_revoke_rules_on_delete

  # Egress rules from user configuration
  dynamic "egress" {
    for_each = var.security_group_egress_rules
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = coalesce(egress.value.ip_protocol, "tcp")
      cidr_blocks = egress.value.cidr_ipv4 != null ? [egress.value.cidr_ipv4] : null
      ipv6_cidr_blocks = egress.value.cidr_ipv6 != null ? [egress.value.cidr_ipv6] : null
      prefix_list_ids = egress.value.prefix_list_id != null ? [egress.value.prefix_list_id] : null
      security_groups = egress.value.referenced_security_group_id != null ? [egress.value.referenced_security_group_id] : null
      description = egress.value.description
    }
  }

  # Default egress rule (allow all outbound)
  dynamic "egress" {
    for_each = var.default_egress_rule.enabled ? [var.default_egress_rule] : []
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      description = egress.value.description
    }
  }

  # Ingress rules from user configuration
  dynamic "ingress" {
    for_each = var.security_group_ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = coalesce(ingress.value.ip_protocol, "tcp")
      cidr_blocks = ingress.value.cidr_ipv4 != null ? [ingress.value.cidr_ipv4] : null
      ipv6_cidr_blocks = ingress.value.cidr_ipv6 != null ? [ingress.value.cidr_ipv6] : null
      prefix_list_ids = ingress.value.prefix_list_id != null ? [ingress.value.prefix_list_id] : null
      security_groups = ingress.value.referenced_security_group_id != null ? [ingress.value.referenced_security_group_id] : null
      description = ingress.value.description
    }
  }

  # Common ingress rules
  dynamic "ingress" {
    for_each = var.enable_common_ingress_rules ? var.common_ingress_rules : []
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  tags = merge(
    var.common_tags,
    var.security_group_tags,
    {
      Name = var.security_group_name
      Module = "security-groups"
      Description = var.security_group_description
      CommonRulesEnabled = var.enable_common_ingress_rules
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Data source for instance subnet
data "aws_subnet" "instance_subnet" {
  id = var.subnet_id
}
