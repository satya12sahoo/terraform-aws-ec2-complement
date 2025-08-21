# =============================================================================
# LOAD BALANCER MODULE - ALB, Target Group, Listener, and Security Group
# =============================================================================

# Security Group for ALB
resource "aws_security_group" "alb" {
  count = var.create_load_balancer ? 1 : 0

  name = var.security_group_name
  description = var.security_group_description
  vpc_id = data.aws_subnet.lb_subnet.vpc_id

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
      Module = "load-balancer"
      Description = var.security_group_description
    }
  )
}

# Target Group for instance
resource "aws_lb_target_group" "instance_tg" {
  count = var.create_load_balancer ? 1 : 0

  name = var.target_group_name
  port = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id = data.aws_subnet.lb_subnet.vpc_id
  target_type = var.target_group_target_type

  health_check {
    enabled = var.health_check_enabled
    healthy_threshold = var.health_check_healthy_threshold
    interval = var.health_check_interval
    matcher = var.health_check_matcher
    path = var.health_check_path
    port = var.health_check_port
    protocol = var.health_check_protocol
    timeout = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.target_group_name
      Module = "load-balancer"
      Description = var.target_group_description
    }
  )
}

# Application Load Balancer
resource "aws_lb" "instance_alb" {
  count = var.create_load_balancer ? 1 : 0

  name = var.load_balancer_name
  internal = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type
  security_groups = [aws_security_group.alb[0].id]
  subnets = [var.subnet_id]

  enable_deletion_protection = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  idle_timeout = var.idle_timeout

  tags = merge(
    var.common_tags,
    {
      Name = var.load_balancer_name
      Module = "load-balancer"
      Description = var.load_balancer_description
      Internal = var.load_balancer_internal
    }
  )
}

# Load Balancer Listener
resource "aws_lb_listener" "instance_listener" {
  count = var.create_load_balancer ? 1 : 0

  load_balancer_arn = aws_lb.instance_alb[0].arn
  port = var.listener_port
  protocol = var.listener_protocol

  default_action {
    type = var.listener_default_action_type
    target_group_arn = aws_lb_target_group.instance_tg[0].arn
  }
}

# Data source for load balancer subnet
data "aws_subnet" "lb_subnet" {
  id = var.subnet_id
}
