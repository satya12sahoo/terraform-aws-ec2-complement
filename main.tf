# =============================================================================
# TERRAFORM AWS EC2 INSTANCE WRAPPER
# =============================================================================
#
# This module is a wrapper around the terraform-aws-modules/ec2-instance/aws module that
# provides enhanced functionality including:
#
# - Multiple instance creation with for_each
# - Default configuration with instance-specific overrides
# - Enhanced security features
# - Monitoring and observability
# - Cost optimization
# - Backup and disaster recovery
# - Network and connectivity
# - Compliance and governance
# - Performance and scaling
# - Advanced features
# - Dynamic templates
#
# The module is organized into separate sub-modules for better maintainability:
#
# - modules/cloudwatch/ - CloudWatch logs and EventBridge
# - modules/vpc-endpoints/ - VPC endpoints and security groups
# - modules/load-balancer/ - ALB, target groups, and listeners
# - modules/autoscaling/ - Auto Scaling Groups and policies
# - modules/security-groups/ - Instance security groups
#
# =============================================================================

# Call EC2 Instance module - one per instance
module "ec2_instances" {
  for_each = local.enabled_instances
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  # Core variables
  create = each.value.create
  name   = each.value.name
  region = each.value.region

  # Instance configuration
  ami                         = each.value.ami
  ami_ssm_parameter          = each.value.ami_ssm_parameter
  ignore_ami_changes         = each.value.ignore_ami_changes
  associate_public_ip_address = each.value.associate_public_ip_address
  availability_zone          = each.value.availability_zone
  capacity_reservation_specification = each.value.capacity_reservation_specification
  cpu_options                = each.value.cpu_options
  cpu_credits                = each.value.cpu_credits
  disable_api_termination    = each.value.disable_api_termination
  disable_api_stop           = each.value.disable_api_stop
  ebs_optimized              = each.value.ebs_optimized
  enclave_options_enabled    = each.value.enclave_options_enabled
  enable_primary_ipv6        = each.value.enable_primary_ipv6
  ephemeral_block_device     = each.value.ephemeral_block_device
  get_password_data          = each.value.get_password_data
  hibernation                = each.value.hibernation
  host_id                    = each.value.host_id
  host_resource_group_arn    = each.value.host_resource_group_arn
  iam_instance_profile       = each.value.iam_instance_profile
  instance_initiated_shutdown_behavior = each.value.instance_initiated_shutdown_behavior
  instance_market_options    = each.value.instance_market_options
  instance_type              = each.value.instance_type
  ipv6_address_count         = each.value.ipv6_address_count
  ipv6_addresses             = each.value.ipv6_addresses
  key_name                   = each.value.key_name
  launch_template            = each.value.launch_template
  maintenance_options        = each.value.maintenance_options
  metadata_options           = each.value.metadata_options
  monitoring                 = each.value.monitoring
  network_interface          = each.value.network_interface
  placement_group            = each.value.placement_group
  placement_partition_number = each.value.placement_partition_number
  private_dns_name_options   = each.value.private_dns_name_options
  private_ip                 = each.value.private_ip
  root_block_device          = each.value.root_block_device
  secondary_private_ips      = each.value.secondary_private_ips
  source_dest_check          = each.value.source_dest_check
  subnet_id                  = each.value.subnet_id
  tags                       = each.value.tags
  instance_tags              = each.value.instance_tags
  tenancy                    = each.value.tenancy
  user_data                  = each.value.user_data
  user_data_base64           = each.value.user_data_base64
  user_data_replace_on_change = each.value.user_data_replace_on_change
  volume_tags                = each.value.volume_tags
  enable_volume_tags         = each.value.enable_volume_tags
  vpc_security_group_ids     = each.value.vpc_security_group_ids
  timeouts                   = each.value.timeouts

  # Spot instance configuration
  create_spot_instance              = each.value.create_spot_instance
  spot_instance_interruption_behavior = each.value.spot_instance_interruption_behavior
  spot_launch_group                 = each.value.spot_launch_group
  spot_price                        = each.value.spot_price
  spot_type                         = each.value.spot_type
  spot_wait_for_fulfillment         = each.value.spot_wait_for_fulfillment
  spot_valid_from                   = each.value.spot_valid_from
  spot_valid_until                  = each.value.spot_valid_until

  # EBS volumes
  ebs_volumes = each.value.ebs_volumes

  # IAM configuration (handled by terraform-aws-modules/ec2-instance/aws)
  create_iam_instance_profile    = each.value.create_iam_instance_profile
  iam_role_name                  = each.value.iam_role_name
  iam_role_use_name_prefix       = each.value.iam_role_use_name_prefix
  iam_role_path                  = each.value.iam_role_path
  iam_role_description           = each.value.iam_role_description
  iam_role_permissions_boundary  = each.value.iam_role_permissions_boundary
  iam_role_policies              = each.value.iam_role_policies
  iam_role_tags                  = each.value.iam_role_tags

  # IAM Instance Profile configuration (handled by terraform-aws-modules/ec2-instance/aws)
  create_instance_profile_for_existing_role = each.value.create_instance_profile_for_existing_role
  instance_profile_name = coalesce(
    each.value.instance_profile_name,
    var.defaults.instance_profile_name,
    "${var.name_prefix}${each.key}-profile"
  )
  instance_profile_path = coalesce(
    each.value.instance_profile_path,
    var.defaults.instance_profile_path,
    "/"
  )
  instance_profile_tags = coalesce(
    each.value.instance_profile_tags,
    var.defaults.instance_profile_tags,
    {}
  )
  instance_profile_description = coalesce(
    each.value.instance_profile_description,
    var.defaults.instance_profile_description,
    "Instance profile for ${each.key}"
  )

  # Security group configuration (handled by terraform-aws-modules/ec2-instance/aws)
  create_security_group          = each.value.create_security_group
  security_group_name            = each.value.security_group_name
  security_group_use_name_prefix = each.value.security_group_use_name_prefix
  security_group_description     = each.value.security_group_description
  security_group_vpc_id          = each.value.security_group_vpc_id
  security_group_tags            = each.value.security_group_tags
  security_group_egress_rules    = each.value.security_group_egress_rules
  security_group_ingress_rules   = each.value.security_group_ingress_rules

  # Elastic IP configuration (handled by terraform-aws-modules/ec2-instance/aws)
  create_eip = each.value.create_eip
  eip_domain = each.value.eip_domain
  eip_tags   = each.value.eip_tags
}

# Call CloudWatch module for logs and scheduling - one per instance
module "cloudwatch" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if (v.create_cloudwatch_agent && v.cloudwatch_agent_config != null && v.cloudwatch_agent_config.create_log_group) || v.create_scheduling
  }
  source = "./modules/cloudwatch"

  create_log_group = each.value.create_cloudwatch_agent && each.value.cloudwatch_agent_config != null && each.value.cloudwatch_agent_config.create_log_group
  log_group_name = each.value.create_cloudwatch_agent && each.value.cloudwatch_agent_config != null ? coalesce(
    each.value.cloudwatch_agent_config.log_group_name,
    var.defaults.cloudwatch_agent_config != null ? var.defaults.cloudwatch_agent_config.log_group_name : null,
    "/aws/ec2/${each.value.name}"
  ) : null
  log_retention_days = each.value.create_cloudwatch_agent && each.value.cloudwatch_agent_config != null ? coalesce(
    each.value.cloudwatch_agent_config.log_retention_days,
    var.defaults.cloudwatch_agent_config != null ? var.defaults.cloudwatch_agent_config.log_retention_days : null,
    30
  ) : coalesce(
    var.defaults.cloudwatch_agent_config != null ? var.defaults.cloudwatch_agent_config.log_retention_days : null,
    30
  )
  log_group_kms_key_id = each.value.create_cloudwatch_agent && each.value.cloudwatch_agent_config != null ? coalesce(
    each.value.cloudwatch_agent_config.kms_key_id,
    var.defaults.cloudwatch_agent_config != null ? var.defaults.cloudwatch_agent_config.kms_key_id : null
  ) : null
  log_group_skip_destroy = each.value.create_cloudwatch_agent && each.value.cloudwatch_agent_config != null ? coalesce(
    each.value.cloudwatch_agent_config.skip_destroy,
    var.defaults.cloudwatch_agent_config != null ? var.defaults.cloudwatch_agent_config.skip_destroy : null,
    false
  ) : coalesce(
    var.defaults.cloudwatch_agent_config != null ? var.defaults.cloudwatch_agent_config.skip_destroy : null,
    false
  )
  
  enable_scheduling = each.value.create_scheduling
  instance_name = each.value.name
  schedule_rule_name = each.value.create_scheduling ? "${var.name_prefix}${each.key}-schedule" : null
  schedule_expression = each.value.create_scheduling && each.value.schedule_config != null ? coalesce(
    each.value.schedule_config.start_schedule,
    var.defaults.schedule_config != null ? var.defaults.schedule_config.start_schedule : null,
    "cron(0 8 ? * MON-FRI *)"
  ) : coalesce(
    var.defaults.schedule_config != null ? var.defaults.schedule_config.start_schedule : null,
    "cron(0 8 ? * MON-FRI *)"
  )
  schedule_timezone = each.value.create_scheduling && each.value.schedule_config != null ? coalesce(
    each.value.schedule_config.timezone,
    var.defaults.schedule_config != null ? var.defaults.schedule_config.timezone : null,
    "UTC"
  ) : coalesce(
    var.defaults.schedule_config != null ? var.defaults.schedule_config.timezone : null,
    "UTC"
  )
  schedule_description = each.value.create_scheduling ? coalesce(
    each.value.schedule_description,
    var.defaults.schedule_description,
    "Schedule for instance ${each.key}"
  ) : coalesce(
    var.defaults.schedule_description,
    "Schedule for EC2 instance start/stop"
  )
  eventbridge_role_name = each.value.create_scheduling ? coalesce(
    each.value.eventbridge_role_name,
    var.defaults.eventbridge_role_name,
    "${var.name_prefix}${each.key}-eventbridge-role"
  ) : null
  eventbridge_policy_name = each.value.create_scheduling ? coalesce(
    each.value.eventbridge_policy_name,
    var.defaults.eventbridge_policy_name,
    "${var.name_prefix}${each.key}-eventbridge-policy"
  ) : null
  eventbridge_role_description = each.value.create_scheduling ? coalesce(
    each.value.eventbridge_role_description,
    var.defaults.eventbridge_role_description,
    "IAM role for EventBridge to manage instance ${each.key}"
  ) : coalesce(
    var.defaults.eventbridge_role_description,
    "IAM role for EventBridge to manage EC2 instances"
  )
  eventbridge_policy_description = each.value.create_scheduling ? coalesce(
    each.value.eventbridge_policy_description,
    var.defaults.eventbridge_policy_description,
    "Policy allowing EventBridge to start/stop instance ${each.key}"
  ) : coalesce(
    var.defaults.eventbridge_policy_description,
    "Policy allowing EventBridge to start/stop EC2 instances"
  )
  enable_stop_schedule = each.value.create_scheduling && each.value.schedule_config != null ? coalesce(
    each.value.schedule_config.enable_stop_schedule,
    var.defaults.schedule_config != null ? var.defaults.schedule_config.enable_stop_schedule : null,
    false
  ) : coalesce(
    var.defaults.schedule_config != null ? var.defaults.schedule_config.enable_stop_schedule : null,
    false
  )
  stop_schedule_expression = each.value.create_scheduling && each.value.schedule_config != null ? coalesce(
    each.value.schedule_config.stop_schedule,
    var.defaults.schedule_config != null ? var.defaults.schedule_config.stop_schedule : null,
    "cron(0 18 ? * MON-FRI *)"
  ) : coalesce(
    var.defaults.schedule_config != null ? var.defaults.schedule_config.stop_schedule : null,
    "cron(0 18 ? * MON-FRI *)"
  )
  schedule_target_arn = each.value.create_scheduling && each.value.schedule_config != null ? each.value.schedule_config.target_arn : null
  common_tags = var.common_tags
}

# Call VPC Endpoints module - one per instance
module "vpc_endpoints" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.create_vpc_endpoints && v.subnet_id != null
  }
  source = "./modules/vpc-endpoints"

  create_vpc_endpoint = each.value.create_vpc_endpoints
  subnet_id = each.value.subnet_id
  service_name = each.value.vpc_endpoints != null ? each.value.vpc_endpoints[0] : "com.amazonaws.region.ec2"
  security_group_name = "${var.name_prefix}${each.key}-vpc-endpoint-sg"
  endpoint_name = "${var.name_prefix}${each.key}-vpc-endpoint"
  vpc_endpoint_type = coalesce(each.value.vpc_endpoint_type, "Interface")
  private_dns_enabled = coalesce(each.value.private_dns_enabled, true)
  policy = each.value.vpc_endpoint_policy
  security_group_description = "Security group for VPC endpoint ${each.key}"
  security_group_rules = coalesce(each.value.vpc_endpoint_security_group_rules, [
    {
      type = "ingress"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access for VPC endpoints"
    },
    {
      type = "egress"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound traffic"
    }
  ])
  endpoint_description = "VPC endpoint for instance ${each.key}"
  enable_dns_hostnames = coalesce(each.value.enable_dns_hostnames, false)
  common_tags = var.common_tags
}

# Call Load Balancer module - one per instance
module "load_balancer" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.create_load_balancer && v.subnet_id != null
  }
  source = "./modules/load-balancer"

  create_load_balancer = each.value.create_load_balancer
  subnet_id = each.value.subnet_id
  security_group_name = "${var.name_prefix}${each.key}-alb-sg"
  target_group_name = "${var.name_prefix}${each.key}-tg"
  target_group_port = each.value.load_balancer_config != null ? coalesce(each.value.load_balancer_config.port, 80) : 80
  target_group_protocol = each.value.load_balancer_config != null ? coalesce(each.value.load_balancer_config.protocol, "HTTP") : "HTTP"
  health_check_path = each.value.load_balancer_config != null ? coalesce(each.value.load_balancer_config.health_check_path, "/") : "/"
  health_check_port = each.value.load_balancer_config != null ? coalesce(each.value.load_balancer_config.health_check_port, 80) : 80
  health_check_protocol = each.value.load_balancer_config != null ? coalesce(each.value.load_balancer_config.health_check_protocol, "HTTP") : "HTTP"
  load_balancer_name = "${var.name_prefix}${each.key}-alb"
  load_balancer_internal = coalesce(each.value.load_balancer_internal, false)
  listener_port = each.value.load_balancer_config != null ? coalesce(each.value.load_balancer_config.listener_port, 80) : 80
  listener_protocol = each.value.load_balancer_config != null ? coalesce(each.value.load_balancer_config.listener_protocol, "HTTP") : "HTTP"
  load_balancer_type = coalesce(each.value.load_balancer_type, "application")
  enable_deletion_protection = coalesce(each.value.enable_deletion_protection, false)
  enable_cross_zone_load_balancing = coalesce(each.value.enable_cross_zone_load_balancing, true)
  idle_timeout = coalesce(each.value.idle_timeout, 60)
  security_group_description = "Security group for ALB ${each.key}"
  security_group_rules = coalesce(each.value.load_balancer_security_group_rules, [
    {
      type = "ingress"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      type = "ingress"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    },
    {
      type = "egress"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound traffic"
    }
  ])
  target_group_target_type = coalesce(each.value.target_group_target_type, "instance")
  health_check_enabled = coalesce(each.value.health_check_enabled, true)
  health_check_interval = coalesce(each.value.health_check_interval, 30)
  health_check_timeout = coalesce(each.value.health_check_timeout, 5)
  health_check_healthy_threshold = coalesce(each.value.health_check_healthy_threshold, 2)
  health_check_unhealthy_threshold = coalesce(each.value.health_check_unhealthy_threshold, 2)
  health_check_matcher = coalesce(each.value.health_check_matcher, "200")
  listener_default_action_type = coalesce(each.value.listener_default_action_type, "forward")
  load_balancer_description = "Application Load Balancer for instance ${each.key}"
  target_group_description = "Target group for instance ${each.key}"
  common_tags = var.common_tags
}

# Call Auto Scaling module - one per instance
module "autoscaling" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.create_auto_scaling_group && v.subnet_id != null
  }
  source = "./modules/autoscaling"

  create_auto_scaling_group = each.value.create_auto_scaling_group
  subnet_id = each.value.subnet_id
  asg_name = "${var.name_prefix}${each.key}-asg"
  min_size = each.value.asg_config != null ? coalesce(each.value.asg_config.min_size, 1) : 1
  max_size = each.value.asg_config != null ? coalesce(each.value.asg_config.max_size, 3) : 3
  desired_capacity = each.value.asg_config != null ? coalesce(each.value.asg_config.desired_capacity, 1) : 1
  health_check_type = each.value.asg_config != null ? coalesce(each.value.asg_config.health_check_type, "EC2") : "EC2"
  health_check_grace_period = each.value.asg_config != null ? coalesce(each.value.asg_config.health_check_grace_period, 300) : 300
  cooldown = each.value.asg_config != null ? coalesce(each.value.asg_config.cooldown, 300) : 300
  enable_scale_in_protection = each.value.asg_config != null ? coalesce(each.value.asg_config.enable_scale_in_protection, false) : false
  launch_template_name = each.value.launch_template_name
  scale_out_policy_name = "${var.name_prefix}${each.key}-scale-out"
  scale_in_policy_name = "${var.name_prefix}${each.key}-scale-in"
  scale_out_alarm_name = "${var.name_prefix}${each.key}-scale-out-alarm"
  scale_in_alarm_name = "${var.name_prefix}${each.key}-scale-in-alarm"
  asg_description = "Auto Scaling Group for instance ${each.key}"
  launch_template_version = coalesce(each.value.launch_template_version, "$Latest")
  mixed_instances_policy = each.value.mixed_instances_policy
  scale_out_adjustment = coalesce(each.value.scale_out_adjustment, 1)
  scale_in_adjustment = coalesce(each.value.scale_in_adjustment, -1)
  scale_out_threshold = coalesce(each.value.scale_out_threshold, 80)
  scale_in_threshold = coalesce(each.value.scale_in_threshold, 40)
  alarm_evaluation_periods = coalesce(each.value.alarm_evaluation_periods, 2)
  alarm_period = coalesce(each.value.alarm_period, 120)
  alarm_statistic = coalesce(each.value.alarm_statistic, "Average")
  alarm_namespace = coalesce(each.value.alarm_namespace, "AWS/EC2")
  alarm_metric_name = coalesce(each.value.alarm_metric_name, "CPUUtilization")
  scale_out_alarm_description = "Scale out if CPU > ${coalesce(each.value.scale_out_threshold, 80)}% for ${coalesce(each.value.alarm_evaluation_periods, 2) * coalesce(each.value.alarm_period, 120) / 60} minutes"
  scale_in_alarm_description = "Scale in if CPU < ${coalesce(each.value.scale_in_threshold, 40)}% for ${coalesce(each.value.alarm_evaluation_periods, 2) * coalesce(each.value.alarm_period, 120) / 60} minutes"
  enable_instance_refresh = coalesce(each.value.enable_instance_refresh, false)
  instance_refresh_strategy = coalesce(each.value.instance_refresh_strategy, "Rolling")
  instance_refresh_min_healthy_percentage = coalesce(each.value.instance_refresh_min_healthy_percentage, 50)
  enable_metrics_collection = coalesce(each.value.enable_metrics_collection, true)
  metrics_granularity = coalesce(each.value.metrics_granularity, "1Minute")
  suspended_processes = coalesce(each.value.suspended_processes, [])
  common_tags = var.common_tags
}


