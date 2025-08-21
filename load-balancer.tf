# Load Balancer Resources

# Create Application Load Balancer Target Groups
resource "aws_lb_target_group" "instance_tg" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_load_balancer && v.load_balancer_config != null
  }

  name_prefix = "${each.value.name}-tg-"
  port        = each.value.load_balancer_config.port
  protocol    = each.value.load_balancer_config.protocol
  vpc_id      = data.aws_subnet.lb_subnet[each.key].vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = each.value.load_balancer_config.health_check_path
    port                = each.value.load_balancer_config.health_check_port
    protocol            = each.value.load_balancer_config.health_check_protocol
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = merge(
    each.value.tags,
    {
      Name = "${each.value.name}-target-group"
      Purpose = "Load balancer target group"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Create Application Load Balancer
resource "aws_lb" "instance_alb" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_load_balancer && v.load_balancer_config != null
  }

  name_prefix = "${each.value.name}-alb-"
  internal    = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb[each.key].id]
  subnets            = [each.value.subnet_id]

  enable_deletion_protection = false

  tags = merge(
    each.value.tags,
    {
      Name = "${each.value.name}-alb"
      Purpose = "Application load balancer"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Security group for ALB
resource "aws_security_group" "alb" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_load_balancer && v.load_balancer_config != null
  }

  name_prefix = "${each.value.name}-alb-"
  vpc_id      = data.aws_subnet.lb_subnet[each.key].vpc_id

  ingress {
    from_port   = each.value.load_balancer_config.port
    to_port     = each.value.load_balancer_config.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    each.value.tags,
    {
      Name = "${each.value.name}-alb-sg"
      Purpose = "ALB security group"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Create ALB Listener
resource "aws_lb_listener" "instance_listener" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_load_balancer && v.load_balancer_config != null
  }

  load_balancer_arn = aws_lb.instance_alb[each.key].arn
  port              = each.value.load_balancer_config.port
  protocol          = each.value.load_balancer_config.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_tg[each.key].arn
  }
}
