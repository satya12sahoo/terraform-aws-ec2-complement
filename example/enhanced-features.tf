# Enhanced Features Example - Comprehensive EC2 Instance Wrapper
# This example demonstrates all the new features with toggle switches

module "enhanced_ec2_instances" {
  source = "../"

  # Default configuration with all enhanced features enabled
  defaults = {
    # Core configuration
    instance_type = "t3.micro"
    ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
    
    # Enhanced security defaults
    enable_enhanced_security = true
    enable_imdsv2 = true
    enable_encryption_by_default = true
    enable_security_hardening = false  # Toggle: Enable security hardening
    
    # Monitoring and observability defaults
    enable_cloudwatch_agent = false  # Toggle: Enable CloudWatch agent
    cloudwatch_agent_config = {
      metrics_collection_interval = 60
      log_group_name = null  # Will be auto-generated
      log_stream_name = null  # Will be auto-generated
      create_log_group = true  # Toggle: Create log group or use existing
      log_retention_days = 30
      enable_structured_logging = false  # Toggle: Enable structured logging
      enable_xray_tracing = false  # Toggle: Enable X-Ray tracing
    }
    detailed_monitoring = false  # Toggle: Enable detailed monitoring
    
    # Cost optimization defaults
    enable_scheduling = false  # Toggle: Enable instance scheduling
    schedule_config = {
      start_time = "09:00"
      stop_time = "18:00"
      timezone = "UTC"
      days_of_week = ["monday", "tuesday", "wednesday", "thursday", "friday"]
    }
    enable_cost_optimization = false  # Toggle: Enable cost optimization features
    cost_optimization_config = {
      enable_spot_instances = false
      enable_auto_scaling = false
      enable_rightsizing = false
    }
    
    # Backup and disaster recovery defaults
    enable_automated_backups = false  # Toggle: Enable automated backups
    backup_config = {
      retention_days = 7
      backup_window = "03:00-04:00"
      maintenance_window = "sun:04:00-sun:05:00"
      copy_tags_to_snapshot = true
      enable_cross_region_backup = false  # Toggle: Enable cross-region backup
      backup_region = null
    }
    
    # Network and connectivity defaults
    enable_vpc_endpoints = false  # Toggle: Enable VPC endpoints
    vpc_endpoints = [
      "com.amazonaws.region.ec2",
      "com.amazonaws.region.ssm",
      "com.amazonaws.region.ssmmessages"
    ]
    enable_load_balancer = false  # Toggle: Enable load balancer
    load_balancer_config = {
      target_group_arn = null  # Will be created automatically
      port = 80
      protocol = "HTTP"
      health_check_path = "/"
      health_check_port = 80
      health_check_protocol = "HTTP"
    }
    
    # Compliance and governance defaults
    enable_compliance = false  # Toggle: Enable compliance features
    compliance_config = {
      required_tags = {
        Environment = "dev"
        Project = "example"
        Owner = "terraform"
        CostCenter = "default"
        Compliance = "standard"
      }
      enforce_tagging = true
      tag_policies = {
        Environment = {
          required = true
          allowed_values = ["dev", "staging", "prod"]
        }
        Project = {
          required = true
          pattern = "^[a-zA-Z0-9_-]+$"
        }
      }
      enable_audit_logging = true
      enable_encryption = true
    }
    
    # Performance and scaling defaults
    enable_auto_scaling_group = false  # Toggle: Enable auto scaling group
    asg_config = {
      min_size = 1
      max_size = 3
      desired_capacity = 1
      health_check_type = "EC2"
      health_check_grace_period = 300
      cooldown = 300
      enable_scale_in_protection = false
    }
    
    # Advanced features defaults
    enable_advanced_features = false  # Toggle: Enable advanced features
    advanced_features_config = {
      enable_ssm_automation = false
      enable_patch_management = false
      enable_inventory_management = false
      enable_maintenance_windows = false
    }
    
    # Common tags
    tags = {
      Environment = "dev"
      Project = "enhanced-example"
      ManagedBy = "terraform"
      Version = "1.0"
    }
    
    # Security group defaults
    create_security_group = true
    security_group_ingress_rules = {
      ssh = {
        from_port   = 22
        to_port     = 22
        ip_protocol = "tcp"
        cidr_ipv4   = "10.0.0.0/16"
        description = "SSH access from VPC"
      }
    }
    
    # IAM defaults
    create_iam_instance_profile = false
    create_instance_profile_for_existing_role = false
  }

  instances = {
    # Basic instance with minimal features
    basic_instance = {
      name = "basic-instance"
      subnet_id = "subnet-12345678"
      enabled = true  # Toggle: Enable/disable this instance
      
      # Override to disable all enhanced features
      enable_enhanced_security = false
      enable_cloudwatch_agent = false
      enable_scheduling = false
      enable_cost_optimization = false
      enable_automated_backups = false
      enable_vpc_endpoints = false
      enable_load_balancer = false
      enable_compliance = false
      enable_auto_scaling_group = false
      enable_advanced_features = false
    }
    
    # Production web server with all features enabled
    production_web = {
      name = "production-web-server"
      instance_type = "t3.small"
      subnet_id = "subnet-12345678"
      enabled = true
      
      # Enable all enhanced features
      enable_enhanced_security = true
      enable_imdsv2 = true
      enable_encryption_by_default = true
      enable_security_hardening = true
      
      # Monitoring and observability
      enable_cloudwatch_agent = true
      cloudwatch_agent_config = {
        metrics_collection_interval = 30
        log_group_name = "/aws/ec2/production-web-server"
        log_stream_name = "application-logs"
        create_log_group = true
        log_retention_days = 90
        enable_structured_logging = true
        enable_xray_tracing = true
      }
      detailed_monitoring = true
      
      # Cost optimization
      enable_scheduling = true
      schedule_config = {
        start_time = "08:00"
        stop_time = "20:00"
        timezone = "UTC"
        days_of_week = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
      }
      enable_cost_optimization = true
      cost_optimization_config = {
        enable_spot_instances = false
        enable_auto_scaling = true
        enable_rightsizing = true
      }
      
      # Backup and disaster recovery
      enable_automated_backups = true
      backup_config = {
        retention_days = 30
        backup_window = "02:00-03:00"
        maintenance_window = "sun:03:00-sun:04:00"
        copy_tags_to_snapshot = true
        enable_cross_region_backup = true
        backup_region = "us-west-2"
      }
      
      # Network and connectivity
      enable_vpc_endpoints = true
      vpc_endpoints = [
        "com.amazonaws.region.ec2",
        "com.amazonaws.region.ssm",
        "com.amazonaws.region.ssmmessages",
        "com.amazonaws.region.s3"
      ]
      enable_load_balancer = true
      load_balancer_config = {
        target_group_arn = null
        port = 80
        protocol = "HTTP"
        health_check_path = "/health"
        health_check_port = 80
        health_check_protocol = "HTTP"
      }
      
      # Compliance and governance
      enable_compliance = true
      compliance_config = {
        required_tags = {
          Environment = "prod"
          Project = "production-web"
          Owner = "devops-team"
          CostCenter = "web-infrastructure"
          Compliance = "pci-dss"
        }
        enforce_tagging = true
        tag_policies = {
          Environment = {
            required = true
            allowed_values = ["prod"]
          }
          Compliance = {
            required = true
            allowed_values = ["pci-dss", "sox", "hipaa"]
          }
        }
        enable_audit_logging = true
        enable_encryption = true
      }
      
      # Performance and scaling
      enable_auto_scaling_group = true
      asg_config = {
        min_size = 2
        max_size = 10
        desired_capacity = 2
        health_check_type = "ELB"
        health_check_grace_period = 300
        cooldown = 300
        enable_scale_in_protection = true
      }
      
      # Advanced features
      enable_advanced_features = true
      advanced_features_config = {
        enable_ssm_automation = true
        enable_patch_management = true
        enable_inventory_management = true
        enable_maintenance_windows = true
      }
      
      # Security group overrides for web server
      security_group_ingress_rules = {
        http = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "HTTP access"
        }
        https = {
          from_port   = 443
          to_port     = 443
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "HTTPS access"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
      
      # Production tags
      tags = {
        Environment = "prod"
        Project = "production-web"
        Role = "web-server"
        Tier = "frontend"
        ManagedBy = "terraform"
        Version = "1.0"
      }
      
      # Enable EIP for web server
      create_eip = true
    }
    
    # Development instance with selective features
    development_instance = {
      name = "development-instance"
      instance_type = "t3.micro"
      subnet_id = "subnet-12345678"
      enabled = true
      
      # Enable only monitoring and basic security
      enable_enhanced_security = true
      enable_imdsv2 = true
      enable_encryption_by_default = true
      enable_security_hardening = false
      
      # Basic monitoring
      enable_cloudwatch_agent = true
      cloudwatch_agent_config = {
        metrics_collection_interval = 60
        log_group_name = "/aws/ec2/development-instance"
        log_stream_name = "dev-logs"
        create_log_group = true
        log_retention_days = 7
        enable_structured_logging = false
        enable_xray_tracing = false
      }
      detailed_monitoring = false
      
      # Cost optimization for dev
      enable_scheduling = true
      schedule_config = {
        start_time = "09:00"
        stop_time = "17:00"
        timezone = "UTC"
        days_of_week = ["monday", "tuesday", "wednesday", "thursday", "friday"]
      }
      enable_cost_optimization = true
      cost_optimization_config = {
        enable_spot_instances = true
        enable_auto_scaling = false
        enable_rightsizing = false
      }
      
      # Disable other features for dev
      enable_automated_backups = false
      enable_vpc_endpoints = false
      enable_load_balancer = false
      enable_compliance = false
      enable_auto_scaling_group = false
      enable_advanced_features = false
      
      # Development tags
      tags = {
        Environment = "dev"
        Project = "development"
        Role = "development-server"
        Tier = "development"
        ManagedBy = "terraform"
        Version = "1.0"
      }
    }
    
    # Database instance with specific features
    database_instance = {
      name = "database-instance"
      instance_type = "t3.medium"
      subnet_id = "subnet-12345678"
      enabled = true
      
      # Enhanced security for database
      enable_enhanced_security = true
      enable_imdsv2 = true
      enable_encryption_by_default = true
      enable_security_hardening = true
      
      # Monitoring for database
      enable_cloudwatch_agent = true
      cloudwatch_agent_config = {
        metrics_collection_interval = 30
        log_group_name = "/aws/ec2/database-instance"
        log_stream_name = "database-logs"
        create_log_group = true
        log_retention_days = 30
        enable_structured_logging = true
        enable_xray_tracing = false
      }
      detailed_monitoring = true
      
      # No scheduling for database (always on)
      enable_scheduling = false
      enable_cost_optimization = false
      
      # Backup for database
      enable_automated_backups = true
      backup_config = {
        retention_days = 14
        backup_window = "01:00-02:00"
        maintenance_window = "sun:02:00-sun:03:00"
        copy_tags_to_snapshot = true
        enable_cross_region_backup = true
        backup_region = "us-west-2"
      }
      
      # VPC endpoints for database
      enable_vpc_endpoints = true
      vpc_endpoints = [
        "com.amazonaws.region.ec2",
        "com.amazonaws.region.ssm",
        "com.amazonaws.region.ssmmessages"
      ]
      
      # No load balancer for database
      enable_load_balancer = false
      
      # Compliance for database
      enable_compliance = true
      compliance_config = {
        required_tags = {
          Environment = "prod"
          Project = "database"
          Owner = "dba-team"
          CostCenter = "database-infrastructure"
          Compliance = "data-protection"
        }
        enforce_tagging = true
        tag_policies = {
          Environment = {
            required = true
            allowed_values = ["prod"]
          }
          Compliance = {
            required = true
            allowed_values = ["data-protection", "pci-dss"]
          }
        }
        enable_audit_logging = true
        enable_encryption = true
      }
      
      # No auto scaling for database
      enable_auto_scaling_group = false
      
      # Advanced features for database
      enable_advanced_features = true
      advanced_features_config = {
        enable_ssm_automation = true
        enable_patch_management = true
        enable_inventory_management = true
        enable_maintenance_windows = true
      }
      
      # Security group for database
      security_group_ingress_rules = {
        database = {
          from_port   = 3306
          to_port     = 3306
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "Database access from VPC"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
      
      # Database tags
      tags = {
        Environment = "prod"
        Project = "database"
        Role = "database-server"
        Tier = "data"
        ManagedBy = "terraform"
        Version = "1.0"
      }
      
      # EBS volumes for database
      ebs_volumes = {
        data = {
          size = 100
          type = "gp3"
          encrypted = true
          device_name = "/dev/sdf"
          tags = {
            Name = "database-data"
            Purpose = "Database data storage"
          }
        }
        logs = {
          size = 50
          type = "gp3"
          encrypted = true
          device_name = "/dev/sdg"
          tags = {
            Name = "database-logs"
            Purpose = "Database log storage"
          }
        }
      }
    }
    
    # Disabled instance (won't be created)
    disabled_instance = {
      name = "disabled-instance"
      subnet_id = "subnet-12345678"
      enabled = false  # This instance will not be created
      
      # All other configurations are ignored when enabled = false
      instance_type = "t3.micro"
      enable_cloudwatch_agent = true
      enable_scheduling = true
    }
  }
}

# Outputs for the enhanced features
output "enabled_instances" {
  description = "List of enabled instances"
  value       = keys(module.enhanced_ec2_instances.enabled_instances)
}

output "cloudwatch_log_groups" {
  description = "CloudWatch log groups created"
  value       = module.enhanced_ec2_instances.cloudwatch_log_group_names
}

output "load_balancer_dns_names" {
  description = "Load balancer DNS names"
  value       = module.enhanced_ec2_instances.load_balancer_dns_names
}

output "autoscaling_group_names" {
  description = "Auto Scaling group names"
  value       = module.enhanced_ec2_instances.autoscaling_group_names
}

output "vpc_endpoint_ids" {
  description = "VPC endpoint IDs"
  value       = module.enhanced_ec2_instances.vpc_endpoint_ids
}

output "scheduling_rules" {
  description = "EventBridge scheduling rules"
  value       = module.enhanced_ec2_instances.scheduling_rule_names
}

output "security_configurations" {
  description = "Security configurations for all instances"
  value       = module.enhanced_ec2_instances.security_configurations
}

output "monitoring_configurations" {
  description = "Monitoring configurations for all instances"
  value       = module.enhanced_ec2_instances.monitoring_configurations
}

output "cost_optimization_enabled" {
  description = "Cost optimization features enabled"
  value       = module.enhanced_ec2_instances.cost_optimization_enabled
}

output "network_configurations" {
  description = "Network configurations for all instances"
  value       = module.enhanced_ec2_instances.network_configurations
}
