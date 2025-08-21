# =============================================================================
# LOAD BALANCER MODULE OUTPUTS
# =============================================================================

# Load Balancer
output "load_balancer" {
  description = "Application Load Balancer created for instance"
  value = var.create_load_balancer ? aws_lb.instance_alb[0] : null
}

output "load_balancer_name" {
  description = "Name of the Application Load Balancer"
  value = var.create_load_balancer ? aws_lb.instance_alb[0].name : null
}

output "load_balancer_arn" {
  description = "ARN of the Application Load Balancer"
  value = var.create_load_balancer ? aws_lb.instance_alb[0].arn : null
}

output "load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value = var.create_load_balancer ? aws_lb.instance_alb[0].dns_name : null
}

# Target Group
output "target_group" {
  description = "Target group created for instance"
  value = var.create_load_balancer ? aws_lb_target_group.instance_tg[0] : null
}

output "target_group_name" {
  description = "Name of the target group"
  value = var.create_load_balancer ? aws_lb_target_group.instance_tg[0].name : null
}

output "target_group_arn" {
  description = "ARN of the target group"
  value = var.create_load_balancer ? aws_lb_target_group.instance_tg[0].arn : null
}

# Load Balancer Listener
output "load_balancer_listener" {
  description = "Load balancer listener created for instance"
  value = var.create_load_balancer ? aws_lb_listener.instance_listener[0] : null
}

output "load_balancer_listener_arn" {
  description = "ARN of the load balancer listener"
  value = var.create_load_balancer ? aws_lb_listener.instance_listener[0].arn : null
}

# Security Group
output "alb_security_group" {
  description = "ALB security group created for instance"
  value = var.create_load_balancer ? aws_security_group.alb[0] : null
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value = var.create_load_balancer ? aws_security_group.alb[0].id : null
}
