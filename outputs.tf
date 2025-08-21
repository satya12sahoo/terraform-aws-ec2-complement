# =============================================================================
# OUTPUTS FOR EC2 INSTANCE WRAPPER MODULE
# =============================================================================

# Core EC2 Instance outputs (from the EC2 instance child module)
output "instances" {
  description = "Map of all created EC2 instances"
  value       = module.ec2_instances
}

output "instance_ids" {
  description = "Map of instance IDs"
  value       = { for k, v in module.ec2_instances : k => v.id }
}

output "instance_arns" {
  description = "Map of instance ARNs"
  value       = { for k, v in module.ec2_instances : k => v.arn }
}

output "instance_states" {
  description = "Map of instance states"
  value       = { for k, v in module.ec2_instances : k => v.instance_state }
}

output "public_ips" {
  description = "Map of public IP addresses"
  value       = { for k, v in module.ec2_instances : k => v.public_ip }
}

output "private_ips" {
  description = "Map of private IP addresses"
  value       = { for k, v in module.ec2_instances : k => v.private_ip }
}

output "public_dns" {
  description = "Map of public DNS names"
  value       = { for k, v in module.ec2_instances : k => v.public_dns }
}

output "private_dns" {
  description = "Map of private DNS names"
  value       = { for k, v in module.ec2_instances : k => v.private_dns }
}

output "availability_zones" {
  description = "Map of availability zones"
  value       = { for k, v in module.ec2_instances : k => v.availability_zone }
}

output "iam_instance_profile_arns" {
  description = "Map of IAM instance profile ARNs"
  value       = { for k, v in module.ec2_instances : k => v.iam_instance_profile_arn }
}

output "security_group_ids" {
  description = "Map of security group IDs"
  value       = { for k, v in module.ec2_instances : k => v.security_group_id }
}

output "eip_ids" {
  description = "Map of Elastic IP IDs"
  value       = { for k, v in module.ec2_instances : k => v.eip_id }
}

output "eip_public_ips" {
  description = "Map of Elastic IP public IPs"
  value       = { for k, v in module.ec2_instances : k => v.eip_public_ip }
}

output "spot_bid_statuses" {
  description = "Map of spot bid statuses"
  value       = { for k, v in module.ec2_instances : k => v.spot_bid_status }
}

output "spot_request_states" {
  description = "Map of spot request states"
  value       = { for k, v in module.ec2_instances : k => v.spot_request_state }
}

output "spot_instance_ids" {
  description = "Map of spot instance IDs"
  value       = { for k, v in module.ec2_instances : k => v.spot_instance_id }
}

output "root_block_devices" {
  description = "Map of root block device information"
  value       = { for k, v in module.ec2_instances : k => v.root_block_device }
}

output "ebs_block_devices" {
  description = "Map of EBS block device information"
  value       = { for k, v in module.ec2_instances : k => v.ebs_block_device }
}

output "ephemeral_block_devices" {
  description = "Map of ephemeral block device information"
  value       = { for k, v in module.ec2_instances : k => v.ephemeral_block_device }
}

output "tags_all" {
  description = "Map of all tags for all instances"
  value       = { for k, v in module.ec2_instances : k => v.tags_all }
}

output "ipv6_addresses" {
  description = "Map of IPv6 addresses"
  value       = { for k, v in module.ec2_instance : k => v.ipv6_addresses }
}

output "primary_network_interface_ids" {
  description = "Map of primary network interface IDs"
  value       = { for k, v in module.ec2_instance : k => v.primary_network_interface_id }
}

output "outpost_arns" {
  description = "Map of outpost ARNs"
  value       = { for k, v in module.ec2_instance : k => v.outpost_arn }
}

output "password_data" {
  description = "Map of password data"
  value       = { for k, v in module.ec2_instance : k => v.password_data }
}

output "capacity_reservation_specifications" {
  description = "Map of capacity reservation specifications"
  value       = { for k, v in module.ec2_instance : k => v.capacity_reservation_specification }
}

output "amis" {
  description = "Map of AMI IDs"
  value       = { for k, v in module.ec2_instance : k => v.ami }
}

output "iam_role_names" {
  description = "Map of IAM role names"
  value       = { for k, v in module.ec2_instance : k => v.iam_role_name }
}

output "iam_role_unique_ids" {
  description = "Map of IAM role unique IDs"
  value       = { for k, v in module.ec2_instance : k => v.iam_role_unique_id }
}

output "iam_instance_profile_ids" {
  description = "Map of IAM instance profile IDs"
  value       = { for k, v in module.ec2_instance : k => v.iam_instance_profile_id }
}

output "iam_instance_profile_unique_ids" {
  description = "Map of IAM instance profile unique IDs"
  value       = { for k, v in module.ec2_instance : k => v.iam_instance_profile_unique }
}

# =============================================================================
# MODULE-SPECIFIC OUTPUTS
# =============================================================================

# IAM Module Outputs
output "existing_role_instance_profiles" {
  description = "Map of instance profiles created for existing IAM roles"
  value = { for k, v in module.iam : k => v.instance_profile }
}

output "existing_role_instance_profile_names" {
  description = "Map of instance profile names created for existing IAM roles"
  value = { for k, v in module.iam : k => v.instance_profile_name }
}

output "existing_role_instance_profile_arns" {
  description = "Map of instance profile ARNs created for existing IAM roles"
  value = { for k, v in module.iam : k => v.instance_profile_arn }
}

# CloudWatch Module Outputs
output "cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created for instances"
  value = { for k, v in module.cloudwatch : k => v.log_group }
}

output "cloudwatch_log_group_names" {
  description = "Map of CloudWatch log group names"
  value = { for k, v in module.cloudwatch : k => v.log_group_name }
}

output "cloudwatch_log_group_arns" {
  description = "Map of CloudWatch log group ARNs"
  value = { for k, v in module.cloudwatch : k => v.log_group_arn }
}

output "scheduling_rules" {
  description = "Map of EventBridge rules created for instance scheduling"
  value = { for k, v in module.cloudwatch : k => v.scheduling_rule }
}

output "scheduling_rule_names" {
  description = "Map of EventBridge rule names"
  value = { for k, v in module.cloudwatch : k => v.scheduling_rule_name }
}

output "scheduling_rule_arns" {
  description = "Map of EventBridge rule ARNs"
  value = { for k, v in module.cloudwatch : k => v.scheduling_rule_arn }
}

output "scheduling_targets" {
  description = "Map of EventBridge targets created for instance scheduling"
  value = { for k, v in module.cloudwatch : k => v.scheduling_target }
}

output "eventbridge_roles" {
  description = "Map of IAM roles for EventBridge"
  value = { for k, v in module.cloudwatch : k => v.eventbridge_role }
}

output "eventbridge_role_arns" {
  description = "Map of IAM role ARNs for EventBridge"
  value = { for k, v in module.cloudwatch : k => v.eventbridge_role_arn }
}

# VPC Endpoints Module Outputs
output "vpc_endpoints" {
  description = "Map of VPC endpoints created for instances"
  value = { for k, v in module.vpc_endpoints : k => v.vpc_endpoint }
}

output "vpc_endpoint_ids" {
  description = "Map of VPC endpoint IDs"
  value = { for k, v in module.vpc_endpoints : k => v.vpc_endpoint_id }
}

output "vpc_endpoint_arns" {
  description = "Map of VPC endpoint ARNs"
  value = { for k, v in module.vpc_endpoints : k => v.vpc_endpoint_arn }
}

output "vpc_endpoint_security_groups" {
  description = "Map of VPC endpoint security groups created for instances"
  value = { for k, v in module.vpc_endpoints : k => v.vpc_endpoint_security_group }
}

output "vpc_endpoint_security_group_ids" {
  description = "Map of VPC endpoint security group IDs"
  value = { for k, v in module.vpc_endpoints : k => v.vpc_endpoint_security_group_id }
}

# Load Balancer Module Outputs
output "load_balancers" {
  description = "Map of Application Load Balancers created for instances"
  value = { for k, v in module.load_balancer : k => v.load_balancer }
}

output "load_balancer_names" {
  description = "Map of Application Load Balancer names"
  value = { for k, v in module.load_balancer : k => v.load_balancer_name }
}

output "load_balancer_arns" {
  description = "Map of Application Load Balancer ARNs"
  value = { for k, v in module.load_balancer : k => v.load_balancer_arn }
}

output "load_balancer_dns_names" {
  description = "Map of Application Load Balancer DNS names"
  value = { for k, v in module.load_balancer : k => v.load_balancer_dns_name }
}

output "target_groups" {
  description = "Map of target groups created for instances"
  value = { for k, v in module.load_balancer : k => v.target_group }
}

output "target_group_names" {
  description = "Map of target group names"
  value = { for k, v in module.load_balancer : k => v.target_group_name }
}

output "target_group_arns" {
  description = "Map of target group ARNs"
  value = { for k, v in module.load_balancer : k => v.target_group_arn }
}

output "load_balancer_listeners" {
  description = "Map of load balancer listeners created for instances"
  value = { for k, v in module.load_balancer : k => v.load_balancer_listener }
}

output "load_balancer_listener_arns" {
  description = "Map of load balancer listener ARNs"
  value = { for k, v in module.load_balancer : k => v.load_balancer_listener_arn }
}

output "alb_security_groups" {
  description = "Map of ALB security groups created for instances"
  value = { for k, v in module.load_balancer : k => v.alb_security_group }
}

output "alb_security_group_ids" {
  description = "Map of ALB security group IDs"
  value = { for k, v in module.load_balancer : k => v.alb_security_group_id }
}

# Auto Scaling Module Outputs
output "autoscaling_groups" {
  description = "Map of Auto Scaling groups created for instances"
  value = { for k, v in module.autoscaling : k => v.autoscaling_group }
}

output "autoscaling_group_names" {
  description = "Map of Auto Scaling group names"
  value = { for k, v in module.autoscaling : k => v.autoscaling_group_name }
}

output "autoscaling_group_arns" {
  description = "Map of Auto Scaling group ARNs"
  value = { for k, v in module.autoscaling : k => v.autoscaling_group_arn }
}

output "scale_out_policies" {
  description = "Map of scale out policies"
  value = { for k, v in module.autoscaling : k => v.scale_out_policy }
}

output "scale_in_policies" {
  description = "Map of scale in policies"
  value = { for k, v in module.autoscaling : k => v.scale_in_policy }
}

output "scale_out_alarms" {
  description = "Map of scale out alarms"
  value = { for k, v in module.autoscaling : k => v.scale_out_alarm }
}

output "scale_in_alarms" {
  description = "Map of scale in alarms"
  value = { for k, v in module.autoscaling : k => v.scale_in_alarm }
}

# Security Groups Module Outputs
output "instance_security_groups" {
  description = "Map of security groups created for instances"
  value = { for k, v in module.security_groups : k => v.instance_security_group }
}

output "instance_security_group_ids" {
  description = "Map of security group IDs"
  value = { for k, v in module.security_groups : k => v.instance_security_group_id }
}

output "instance_security_group_names" {
  description = "Map of security group names"
  value = { for k, v in module.security_groups : k => v.instance_security_group_name }
}

# =============================================================================
# ENHANCED OUTPUTS
# =============================================================================

# Enhanced Instance Information
output "enabled_instances" {
  description = "Map of enabled instances (filtered from all instances)"
  value       = local.enabled_instances
}

output "instance_configurations" {
  description = "Map of final instance configurations after merging defaults"
  value       = local.merged_instances
}

# Compliance and Governance
output "compliance_tags" {
  description = "Map of compliance tags applied to instances"
  value       = {
    for k, v in local.enabled_instances : k => merge(
      v.tags,
      v.enable_compliance && v.compliance_config != null ? v.compliance_config.required_tags : {}
    )
  }
}

# Cost Optimization
output "cost_optimization_enabled" {
  description = "Map of instances with cost optimization enabled"
  value       = {
    for k, v in local.enabled_instances : k => {
      scheduling_enabled = v.enable_scheduling
      cost_optimization_enabled = v.enable_cost_optimization
      spot_instances_enabled = v.create_spot_instance
      auto_scaling_enabled = v.enable_auto_scaling_group
    }
  }
}

# Monitoring and Observability
output "monitoring_configurations" {
  description = "Map of monitoring configurations for instances"
  value       = {
    for k, v in local.enabled_instances : k => {
      cloudwatch_agent_enabled = v.enable_cloudwatch_agent
      detailed_monitoring_enabled = v.detailed_monitoring
      log_group_created = v.enable_cloudwatch_agent && v.cloudwatch_agent_config != null && v.cloudwatch_agent_config.create_log_group
      log_group_name = v.enable_cloudwatch_agent && v.cloudwatch_agent_config != null ? coalesce(v.cloudwatch_agent_config.log_group_name, "/aws/ec2/${v.name}") : null
    }
  }
}

# Security Features
output "security_configurations" {
  description = "Map of security configurations for instances"
  value       = {
    for k, v in local.enabled_instances : k => {
      enhanced_security_enabled = v.enable_enhanced_security
      imdsv2_enabled = v.enable_imdsv2
      encryption_enabled = v.enable_encryption_by_default
      security_hardening_enabled = v.enable_security_hardening
      vpc_endpoints_enabled = v.enable_vpc_endpoints
    }
  }
}

# Network and Connectivity
output "network_configurations" {
  description = "Map of network configurations for instances"
  value       = {
    for k, v in local.enabled_instances : k => {
      load_balancer_enabled = v.enable_load_balancer
      vpc_endpoints_enabled = v.enable_vpc_endpoints
      auto_scaling_enabled = v.enable_auto_scaling_group
      public_ip_enabled = v.associate_public_ip_address
    }
  }
}

# Template outputs
output "available_templates" {
  description = "List of available template names"
  value = keys(local.all_templates)
}

output "template_configurations" {
  description = "Map of template configurations"
  value = local.all_templates
}

output "instances_with_templates" {
  description = "Map of instances that use templates"
  value = {
    for key, config in local.final_instances : key => config.template
    if config.template != null
  }
}

output "template_usage_summary" {
  description = "Summary of template usage across instances"
  value = {
    total_instances = length(local.enabled_instances)
    instances_with_templates = length({
      for key, config in local.final_instances : key => config.template
      if config.template != null
    })
    template_distribution = {
      for template_name in distinct([
        for config in values(local.final_instances) : config.template
        if config.template != null
      ]) : template_name => length([
        for key, config in local.final_instances : key
        if config.template == template_name
      ])
    }
  }
}
