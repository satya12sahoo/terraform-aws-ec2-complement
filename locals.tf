# Local variables and data processing
locals {
  # Merge defaults with individual instance configurations
  merged_instances = {
    for k, v in var.instances : k => merge(var.defaults, v)
  }
  
  # Filter enabled instances
  enabled_instances = {
    for k, v in local.final_instances : k => v
    if v.enabled != false
  }
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Data source for VPC endpoint subnet
data "aws_subnet" "vpc_endpoint_subnet" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_vpc_endpoints && v.subnet_id != null
  }

  id = each.value.subnet_id
}

# Data source for load balancer subnet
data "aws_subnet" "lb_subnet" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.enable_load_balancer && v.load_balancer_config != null
  }

  id = each.value.subnet_id
}
