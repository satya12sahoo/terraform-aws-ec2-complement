# Common variables
variable "name_prefix" {
  description = "Prefix for resource names"
  type = string
  default = ""
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}

# Default variables that apply to all instances
variable "defaults" {
  description = "Default configuration that applies to all instances. Individual instances can override these values."
  type = object({
    # Core variables
    create = optional(bool, true)
    region = optional(string)

    # Instance configuration
    ami                         = optional(string)
    ami_ssm_parameter          = optional(string, "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64")
    ignore_ami_changes         = optional(bool, false)
    associate_public_ip_address = optional(bool)
    availability_zone          = optional(string)
    capacity_reservation_specification = optional(object({
      capacity_reservation_preference = optional(string)
      capacity_reservation_target = optional(object({
        capacity_reservation_id                 = optional(string)
        capacity_reservation_resource_group_arn = optional(string)
      }))
    }))
    cpu_options = optional(object({
      amd_sev_snp      = optional(string)
      core_count       = optional(number)
      threads_per_core = optional(number)
    }))
    cpu_credits                = optional(string)
    disable_api_termination    = optional(bool)
    disable_api_stop           = optional(bool)
    ebs_optimized              = optional(bool)
    enclave_options_enabled    = optional(bool)
    enable_primary_ipv6        = optional(bool)
    ephemeral_block_device     = optional(map(object({
      device_name  = string
      no_device    = optional(bool)
      virtual_name = optional(string)
    })))
    get_password_data                    = optional(bool)
    hibernation                          = optional(bool)
    host_id                              = optional(string)
    host_resource_group_arn              = optional(string)
    iam_instance_profile                 = optional(string)
    instance_initiated_shutdown_behavior = optional(string)
    instance_market_options = optional(object({
      market_type = optional(string)
      spot_options = optional(object({
        instance_interruption_behavior = optional(string)
        max_price                      = optional(string)
        spot_instance_type             = optional(string)
        valid_until                    = optional(string)
      }))
    }))
    instance_type              = optional(string, "t3.micro")
    ipv6_address_count         = optional(number)
    ipv6_addresses             = optional(list(string))
    key_name                   = optional(string)
    launch_template = optional(object({
      id      = optional(string)
      name    = optional(string)
      version = optional(string)
    }))
    maintenance_options = optional(object({
      auto_recovery = optional(string)
    }))
    metadata_options = optional(object({
      http_endpoint               = optional(string, "enabled")
      http_protocol_ipv6          = optional(string)
      http_put_response_hop_limit = optional(number, 1)
      http_tokens                 = optional(string, "required")
      instance_metadata_tags      = optional(string, "disabled")
    }))
    monitoring = optional(bool, true)
    network_interface = optional(map(object({
      delete_on_termination = optional(bool)
      device_index          = optional(number)
      network_card_index    = optional(number)
      network_interface_id  = string
    })))
    placement_group            = optional(string)
    placement_partition_number = optional(number)
    private_dns_name_options = optional(object({
      enable_resource_name_dns_a_record    = optional(bool)
      enable_resource_name_dns_aaaa_record = optional(bool)
      hostname_type                        = optional(string)
    }))
    private_ip            = optional(string)
    root_block_device     = optional(object({
      delete_on_termination = optional(bool, true)
      encrypted             = optional(bool, true)
      iops                  = optional(number)
      kms_key_id            = optional(string)
      tags                  = optional(map(string))
      throughput            = optional(number)
      size                  = optional(number)
      type                  = optional(string, "gp3")
    }))
    secondary_private_ips = optional(list(string))
    source_dest_check     = optional(bool)
    subnet_id             = optional(string)
    tags                  = optional(map(string), {})
    instance_tags         = optional(map(string), {})
    tenancy               = optional(string)
    user_data             = optional(string)
    user_data_base64      = optional(string)
    user_data_replace_on_change = optional(bool)
    volume_tags           = optional(map(string), {})
    enable_volume_tags    = optional(bool, true)
    vpc_security_group_ids = optional(list(string), [])
    timeouts              = optional(map(string), {})

    # Spot instance configuration
    create_spot_instance              = optional(bool, false)
    spot_instance_interruption_behavior = optional(string)
    spot_launch_group                 = optional(string)
    spot_price                        = optional(string)
    spot_type                         = optional(string)
    spot_wait_for_fulfillment         = optional(bool)
    spot_valid_from                   = optional(string)
    spot_valid_until                  = optional(string)

    # EBS volumes
    ebs_volumes = optional(map(object({
      encrypted            = optional(bool)
      final_snapshot       = optional(bool)
      iops                 = optional(number)
      kms_key_id           = optional(string)
      multi_attach_enabled = optional(bool)
      outpost_arn          = optional(string)
      size                 = optional(number)
      snapshot_id          = optional(string)
      tags                 = optional(map(string), {})
      throughput           = optional(number)
      type                 = optional(string, "gp3")
      # Attachment
      device_name                    = optional(string)
      force_detach                   = optional(bool)
      skip_destroy                   = optional(bool)
      stop_instance_before_detaching = optional(bool)
    })))

    # IAM configuration
    create_iam_instance_profile    = optional(bool, false)
    create_instance_profile_for_existing_role = optional(bool, false)
    iam_role_name                  = optional(string)
    iam_role_use_name_prefix       = optional(bool, true)
    iam_role_path                  = optional(string)
    iam_role_description           = optional(string)
    iam_role_permissions_boundary  = optional(string)
    iam_role_policies              = optional(map(string), {})
    iam_role_tags                  = optional(map(string), {})
    instance_profile_name          = optional(string)
    instance_profile_use_name_prefix = optional(bool, true)
    instance_profile_path          = optional(string)
    instance_profile_tags          = optional(map(string), {})

    # Security group configuration
    create_security_group          = optional(bool, true)
    security_group_name            = optional(string)
    security_group_use_name_prefix = optional(bool, true)
    security_group_description     = optional(string)
    security_group_vpc_id          = optional(string)
    security_group_tags            = optional(map(string), {})
    security_group_egress_rules    = optional(map(object({
      cidr_ipv4                    = optional(string)
      cidr_ipv6                    = optional(string)
      description                  = optional(string)
      from_port                    = optional(number)
      ip_protocol                  = optional(string, "tcp")
      prefix_list_id               = optional(string)
      referenced_security_group_id = optional(string)
      tags                         = optional(map(string), {})
      to_port                      = optional(number)
    })))
    security_group_ingress_rules = optional(map(object({
      cidr_ipv4                    = optional(string)
      cidr_ipv6                    = optional(string)
      description                  = optional(string)
      from_port                    = optional(number)
      ip_protocol                  = optional(string, "tcp")
      prefix_list_id               = optional(string)
      referenced_security_group_id = optional(string)
      tags                         = optional(map(string), {})
      to_port                      = optional(number)
    })))

    # Elastic IP configuration
    create_eip = optional(bool, false)
    eip_domain = optional(string, "vpc")
    eip_tags   = optional(map(string), {})

    # NEW FEATURES - Enhanced Configuration

    # 1. Conditional Instance Creation
    enabled = optional(bool, true)
    depends_on = optional(list(string), [])

    # 2. Instance Groups & Tags
    instance_group = optional(string)
    auto_scaling_group = optional(string)

    # 3. Enhanced Security Features
    enable_enhanced_security = optional(bool, true)
    enable_imdsv2 = optional(bool, true)
    enable_encryption_by_default = optional(bool, true)
    enable_security_hardening = optional(bool, false)
    security_hardening_config = optional(object({
      disable_password_auth = optional(bool, true)
      enable_selinux = optional(bool, true)
      enable_audit_logging = optional(bool, true)
    }))

    # 4. Monitoring & Observability
    create_cloudwatch_agent = optional(bool, false)
    cloudwatch_agent_config = optional(object({
      metrics_collection_interval = optional(number, 60)
      log_group_name = optional(string)
      log_stream_name = optional(string)
      create_log_group = optional(bool, false)  # Default to false - use existing
      log_retention_days = optional(number, 30)
      enable_structured_logging = optional(bool, false)
      enable_xray_tracing = optional(bool, false)
    }))
    detailed_monitoring = optional(bool, false)

    # 5. Cost Optimization Features
    create_scheduling = optional(bool, false)
    schedule_config = optional(object({
      start_time = optional(string)
      stop_time = optional(string)
      timezone = optional(string, "UTC")
      days_of_week = optional(list(string), ["monday", "tuesday", "wednesday", "thursday", "friday"])
    }))
    enable_cost_optimization = optional(bool, false)
    cost_optimization_config = optional(object({
      enable_spot_instances = optional(bool, false)
      enable_auto_scaling = optional(bool, false)
      enable_rightsizing = optional(bool, false)
    }))

    # 6. Backup & Disaster Recovery
    enable_automated_backups = optional(bool, false)
    backup_config = optional(object({
      retention_days = optional(number, 7)
      backup_window = optional(string, "03:00-04:00")
      maintenance_window = optional(string, "sun:04:00-sun:05:00")
      copy_tags_to_snapshot = optional(bool, true)
      enable_cross_region_backup = optional(bool, false)
      backup_region = optional(string)
    }))

    # 7. Network & Connectivity
    create_vpc_endpoints = optional(bool, false)
    vpc_endpoints = optional(list(string), [
      "com.amazonaws.region.ec2",
      "com.amazonaws.region.ssm",
      "com.amazonaws.region.ssmmessages"
    ])
    create_load_balancer = optional(bool, false)
    load_balancer_config = optional(object({
      target_group_arn = optional(string)
      port = optional(number, 80)
      protocol = optional(string, "HTTP")
      health_check_path = optional(string, "/")
      health_check_port = optional(number, 80)
      health_check_protocol = optional(string, "HTTP")
    }))

    # 8. Compliance & Governance
    enable_compliance = optional(bool, false)
    compliance_config = optional(object({
      required_tags = optional(map(string), {
        Environment = "dev"
        Project = "default"
        Owner = "terraform"
        CostCenter = "default"
        Compliance = "standard"
      })
      enforce_tagging = optional(bool, true)
      tag_policies = optional(map(object({
        required = optional(bool, true)
        allowed_values = optional(list(string))
        pattern = optional(string)
      })))
      enable_audit_logging = optional(bool, true)
      enable_encryption = optional(bool, true)
    }))

    # 9. Performance & Scaling
    create_auto_scaling_group = optional(bool, false)
    asg_config = optional(object({
      min_size = optional(number, 1)
      max_size = optional(number, 3)
      desired_capacity = optional(number, 1)
      health_check_type = optional(string, "EC2")
      health_check_grace_period = optional(number, 300)
      cooldown = optional(number, 300)
      enable_scale_in_protection = optional(bool, false)
    }))

    # 10. Advanced Features
    enable_advanced_features = optional(bool, false)
    advanced_features_config = optional(object({
      enable_ssm_automation = optional(bool, false)
      enable_patch_management = optional(bool, false)
      enable_inventory_management = optional(bool, false)
      enable_maintenance_windows = optional(bool, false)
    }))
  })
  default = {}
}

# Validation blocks
variable "instances" {
  description = "Map of EC2 instances to create. Each instance can override values from the defaults variable."
  type = map(object({
    # Core variables
    create = optional(bool)
    name   = string
    region = optional(string)

    # Instance configuration
    ami                         = optional(string)
    ami_ssm_parameter          = optional(string)
    ignore_ami_changes         = optional(bool)
    associate_public_ip_address = optional(bool)
    availability_zone          = optional(string)
    capacity_reservation_specification = optional(object({
      capacity_reservation_preference = optional(string)
      capacity_reservation_target = optional(object({
        capacity_reservation_id                 = optional(string)
        capacity_reservation_resource_group_arn = optional(string)
      }))
    }))
    cpu_options = optional(object({
      amd_sev_snp      = optional(string)
      core_count       = optional(number)
      threads_per_core = optional(number)
    }))
    cpu_credits                = optional(string)
    disable_api_termination    = optional(bool)
    disable_api_stop           = optional(bool)
    ebs_optimized              = optional(bool)
    enclave_options_enabled    = optional(bool)
    enable_primary_ipv6        = optional(bool)
    ephemeral_block_device     = optional(map(object({
      device_name  = string
      no_device    = optional(bool)
      virtual_name = optional(string)
    })))
    get_password_data                    = optional(bool)
    hibernation                          = optional(bool)
    host_id                              = optional(string)
    host_resource_group_arn              = optional(string)
    iam_instance_profile                 = optional(string)
    instance_initiated_shutdown_behavior = optional(string)
    instance_market_options = optional(object({
      market_type = optional(string)
      spot_options = optional(object({
        instance_interruption_behavior = optional(string)
        max_price                      = optional(string)
        spot_instance_type             = optional(string)
        valid_until                    = optional(string)
      }))
    }))
    instance_type              = optional(string)
    ipv6_address_count         = optional(number)
    ipv6_addresses             = optional(list(string))
    key_name                   = optional(string)
    launch_template = optional(object({
      id      = optional(string)
      name    = optional(string)
      version = optional(string)
    }))
    maintenance_options = optional(object({
      auto_recovery = optional(string)
    }))
    metadata_options = optional(object({
      http_endpoint               = optional(string)
      http_protocol_ipv6          = optional(string)
      http_put_response_hop_limit = optional(number)
      http_tokens                 = optional(string)
      instance_metadata_tags      = optional(string)
    }))
    monitoring = optional(bool)
    network_interface = optional(map(object({
      delete_on_termination = optional(bool)
      device_index          = optional(number)
      network_card_index    = optional(number)
      network_interface_id  = string
    })))
    placement_group            = optional(string)
    placement_partition_number = optional(number)
    private_dns_name_options = optional(object({
      enable_resource_name_dns_a_record    = optional(bool)
      enable_resource_name_dns_aaaa_record = optional(bool)
      hostname_type                        = optional(string)
    }))
    private_ip            = optional(string)
    root_block_device     = optional(object({
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
      iops                  = optional(number)
      kms_key_id            = optional(string)
      tags                  = optional(map(string))
      throughput            = optional(number)
      size                  = optional(number)
      type                  = optional(string)
    }))
    secondary_private_ips = optional(list(string))
    source_dest_check     = optional(bool)
    subnet_id             = optional(string)
    tags                  = optional(map(string))
    instance_tags         = optional(map(string))
    tenancy               = optional(string)
    user_data             = optional(string)
    user_data_base64      = optional(string)
    user_data_replace_on_change = optional(bool)
    volume_tags           = optional(map(string))
    enable_volume_tags    = optional(bool)
    vpc_security_group_ids = optional(list(string))
    timeouts              = optional(map(string))

    # Spot instance configuration
    create_spot_instance              = optional(bool)
    spot_instance_interruption_behavior = optional(string)
    spot_launch_group                 = optional(string)
    spot_price                        = optional(string)
    spot_type                         = optional(string)
    spot_wait_for_fulfillment         = optional(bool)
    spot_valid_from                   = optional(string)
    spot_valid_until                  = optional(string)

    # EBS volumes
    ebs_volumes = optional(map(object({
      encrypted            = optional(bool)
      final_snapshot       = optional(bool)
      iops                 = optional(number)
      kms_key_id           = optional(string)
      multi_attach_enabled = optional(bool)
      outpost_arn          = optional(string)
      size                 = optional(number)
      snapshot_id          = optional(string)
      tags                 = optional(map(string))
      throughput           = optional(number)
      type                 = optional(string)
      # Attachment
      device_name                    = optional(string)
      force_detach                   = optional(bool)
      skip_destroy                   = optional(bool)
      stop_instance_before_detaching = optional(bool)
    })))

    # IAM configuration
    create_iam_instance_profile    = optional(bool)
    create_instance_profile_for_existing_role = optional(bool)
    iam_role_name                  = optional(string)
    iam_role_use_name_prefix       = optional(bool)
    iam_role_path                  = optional(string)
    iam_role_description           = optional(string)
    iam_role_permissions_boundary  = optional(string)
    iam_role_policies              = optional(map(string))
    iam_role_tags                  = optional(map(string))
    instance_profile_name          = optional(string)
    instance_profile_use_name_prefix = optional(bool)
    instance_profile_path          = optional(string)
    instance_profile_tags          = optional(map(string))

    # Security group configuration
    create_security_group          = optional(bool)
    security_group_name            = optional(string)
    security_group_use_name_prefix = optional(bool)
    security_group_description     = optional(string)
    security_group_vpc_id          = optional(string)
    security_group_tags            = optional(map(string))
    security_group_egress_rules    = optional(map(object({
      cidr_ipv4                    = optional(string)
      cidr_ipv6                    = optional(string)
      description                  = optional(string)
      from_port                    = optional(number)
      ip_protocol                  = optional(string)
      prefix_list_id               = optional(string)
      referenced_security_group_id = optional(string)
      tags                         = optional(map(string))
      to_port                      = optional(number)
    })))
    security_group_ingress_rules = optional(map(object({
      cidr_ipv4                    = optional(string)
      cidr_ipv6                    = optional(string)
      description                  = optional(string)
      from_port                    = optional(number)
      ip_protocol                  = optional(string)
      prefix_list_id               = optional(string)
      referenced_security_group_id = optional(string)
      tags                         = optional(map(string))
      to_port                      = optional(number)
    })))

    # Elastic IP configuration
    create_eip = optional(bool)
    eip_domain = optional(string)
    eip_tags   = optional(map(string))

    # NEW FEATURES - Enhanced Configuration

    # 1. Conditional Instance Creation
    enabled = optional(bool)
    depends_on = optional(list(string))

    # 2. Instance Groups & Tags
    instance_group = optional(string)
    auto_scaling_group = optional(string)

    # 3. Enhanced Security Features
    enable_enhanced_security = optional(bool)
    enable_imdsv2 = optional(bool)
    enable_encryption_by_default = optional(bool)
    enable_security_hardening = optional(bool)
    security_hardening_config = optional(object({
      disable_password_auth = optional(bool)
      enable_selinux = optional(bool)
      enable_audit_logging = optional(bool)
    }))

    # 4. Monitoring & Observability
    enable_cloudwatch_agent = optional(bool)
    cloudwatch_agent_config = optional(object({
      metrics_collection_interval = optional(number)
      log_group_name = optional(string)
      log_stream_name = optional(string)
      create_log_group = optional(bool)
      log_retention_days = optional(number)
      enable_structured_logging = optional(bool)
      enable_xray_tracing = optional(bool)
    }))
    detailed_monitoring = optional(bool)

    # 5. Cost Optimization Features
    enable_scheduling = optional(bool)
    schedule_config = optional(object({
      start_time = optional(string)
      stop_time = optional(string)
      timezone = optional(string)
      days_of_week = optional(list(string))
    }))
    enable_cost_optimization = optional(bool)
    cost_optimization_config = optional(object({
      enable_spot_instances = optional(bool)
      enable_auto_scaling = optional(bool)
      enable_rightsizing = optional(bool)
    }))

    # 6. Backup & Disaster Recovery
    enable_automated_backups = optional(bool)
    backup_config = optional(object({
      retention_days = optional(number)
      backup_window = optional(string)
      maintenance_window = optional(string)
      copy_tags_to_snapshot = optional(bool)
      enable_cross_region_backup = optional(bool)
      backup_region = optional(string)
    }))

    # 7. Network & Connectivity
    enable_vpc_endpoints = optional(bool)
    vpc_endpoints = optional(list(string))
    enable_load_balancer = optional(bool)
    load_balancer_config = optional(object({
      target_group_arn = optional(string)
      port = optional(number)
      protocol = optional(string)
      health_check_path = optional(string)
      health_check_port = optional(number)
      health_check_protocol = optional(string)
    }))

    # 8. Compliance & Governance
    enable_compliance = optional(bool)
    compliance_config = optional(object({
      required_tags = optional(map(string))
      enforce_tagging = optional(bool)
      tag_policies = optional(map(object({
        required = optional(bool)
        allowed_values = optional(list(string))
        pattern = optional(string)
      })))
      enable_audit_logging = optional(bool)
      enable_encryption = optional(bool)
    }))

    # 9. Performance & Scaling
    enable_auto_scaling_group = optional(bool)
    asg_config = optional(object({
      min_size = optional(number)
      max_size = optional(number)
      desired_capacity = optional(number)
      health_check_type = optional(string)
      health_check_grace_period = optional(number)
      cooldown = optional(number)
      enable_scale_in_protection = optional(bool)
    }))

    # 10. Advanced Features
    enable_advanced_features = optional(bool)
    advanced_features_config = optional(object({
      enable_ssm_automation = optional(bool)
      enable_patch_management = optional(bool)
      enable_inventory_management = optional(bool)
      enable_maintenance_windows = optional(bool)
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.instances : 
      can(regex("^[a-zA-Z0-9_-]+$", k)) && length(k) <= 63
    ])
    error_message = "Instance keys must be alphanumeric with hyphens/underscores and max 63 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.instances : 
      v.name != null && v.name != ""
    ])
    error_message = "All instances must have a non-empty name."
  }

  validation {
    condition = alltrue([
      for k, v in var.instances : 
      v.subnet_id == null || can(regex("^subnet-", v.subnet_id))
    ])
    error_message = "Subnet IDs must be valid subnet-* format."
  }

  validation {
    condition = alltrue([
      for k, v in var.instances : 
      v.enabled == null || v.enabled == true || v.enabled == false
    ])
    error_message = "Enabled must be true, false, or null."
  }
}
