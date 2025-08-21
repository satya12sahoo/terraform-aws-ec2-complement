# =============================================================================
# MODULAR ARCHITECTURE USAGE EXAMPLE
# =============================================================================

# Example 1: Full-featured deployment with all modules
module "ec2_wrapper_full" {
  source = "../"

  name_prefix = "full-featured-"
  common_tags = {
    Environment = "production"
    Project = "my-project"
    Team = "devops"
    CostCenter = "IT-001"
  }

  defaults = {
    instance_type = "t3.medium"
    subnet_id = "subnet-12345678"
    vpc_security_group_ids = ["sg-12345678"]
    
    # Enable all enhanced features by default
    enable_enhanced_security = true
    enable_cloudwatch_agent = true
    enable_load_balancer = true
    enable_auto_scaling_group = true
    enable_vpc_endpoints = true
    enable_scheduling = true
    enable_cost_optimization = true
    enable_automated_backups = true
    enable_compliance = true
    enable_advanced_features = true
  }

  instances = {
    # Web server with load balancer and auto scaling
    web = {
      name = "web-server"
      template = "web_server"
      subnet_id = "subnet-87654321"
      
      load_balancer_config = {
        port = 80
        protocol = "HTTP"
        health_check_path = "/health"
        health_check_port = 80
        listener_port = 80
        listener_protocol = "HTTP"
      }
      
      asg_config = {
        min_size = 2
        max_size = 5
        desired_capacity = 2
        cooldown = 300
        health_check_grace_period = 300
      }
      
      cloudwatch_agent_config = {
        create_log_group = true
        log_group_name = "/aws/ec2/web-server"
        log_retention_days = 30
      }
      
      schedule_config = {
        start_schedule = "cron(0 8 ? * MON-FRI *)"
        stop_schedule = "cron(0 18 ? * MON-FRI *)"
        timezone = "UTC"
      }
    }

    # Database server with VPC endpoints and backups
    db = {
      name = "database-server"
      template = "database_server"
      subnet_id = "subnet-87654322"
      instance_type = "t3.large"
      
      enable_vpc_endpoints = true
      vpc_endpoints = [
        "com.amazonaws.region.ec2",
        "com.amazonaws.region.ssm",
        "com.amazonaws.region.ssmmessages"
      ]
      
      enable_automated_backups = true
      backup_config = {
        backup_window = "03:00-04:00"
        maintenance_window = "sun:04:00-sun:05:00"
        backup_retention_period = 7
        delete_automated_backups = false
      }
      
      cloudwatch_agent_config = {
        create_log_group = true
        log_group_name = "/aws/ec2/database-server"
        log_retention_days = 90
      }
    }

    # Application server with scheduling and cost optimization
    app = {
      name = "app-server"
      template = "application_server"
      subnet_id = "subnet-87654323"
      
      enable_scheduling = true
      schedule_config = {
        start_schedule = "cron(0 7 ? * MON-FRI *)"
        stop_schedule = "cron(0 19 ? * MON-FRI *)"
        timezone = "UTC"
      }
      
      enable_cost_optimization = true
      cost_optimization_config = {
        enable_spot_instances = false
        enable_savings_plans = true
        enable_reserved_instances = true
        enable_auto_scaling = true
      }
    }

    # Development server with cost optimization
    dev = {
      name = "dev-server"
      template = "development_server"
      subnet_id = "subnet-87654324"
      instance_type = "t3.small"
      
      enable_scheduling = true
      schedule_config = {
        start_schedule = "cron(0 9 ? * MON-FRI *)"
        stop_schedule = "cron(0 17 ? * MON-FRI *)"
        timezone = "UTC"
      }
      
      enable_cost_optimization = true
      cost_optimization_config = {
        enable_spot_instances = true
        enable_savings_plans = false
        enable_reserved_instances = false
        enable_auto_scaling = false
      }
    }

    # Bastion host with enhanced security
    bastion = {
      name = "bastion-host"
      template = "bastion_host"
      subnet_id = "subnet-87654325"
      
      enable_security_hardening = true
      security_hardening_config = {
        enable_fail2ban = true
        enable_ssh_key_rotation = true
        enable_audit_logging = true
        enable_intrusion_detection = true
      }
      
      enable_vpc_endpoints = true
      vpc_endpoints = [
        "com.amazonaws.region.ssm",
        "com.amazonaws.region.ssmmessages"
      ]
    }
  }
}

# Example 2: Minimal deployment with selective modules
module "ec2_wrapper_minimal" {
  source = "../"

  name_prefix = "minimal-"
  common_tags = {
    Environment = "development"
    Project = "test-project"
  }

  defaults = {
    instance_type = "t3.micro"
    subnet_id = "subnet-12345678"
    vpc_security_group_ids = ["sg-12345678"]
    
    # Disable most features for minimal deployment
    enable_enhanced_security = false
    enable_cloudwatch_agent = false
    enable_load_balancer = false
    enable_auto_scaling_group = false
    enable_vpc_endpoints = false
    enable_scheduling = false
    enable_cost_optimization = false
    enable_automated_backups = false
    enable_compliance = false
    enable_advanced_features = false
  }

  instances = {
    # Simple instance with basic monitoring only
    simple = {
      name = "simple-instance"
      enable_cloudwatch_agent = true
      cloudwatch_agent_config = {
        create_log_group = true
        log_group_name = "/aws/ec2/simple-instance"
        log_retention_days = 7
      }
    }
  }
}

# Example 3: Custom templates with modular architecture
module "ec2_wrapper_custom" {
  source = "../"

  name_prefix = "custom-"
  common_tags = {
    Environment = "staging"
    Project = "custom-project"
  }

  # Define custom templates
  templates = {
    custom_web = {
      description = "Custom web server template"
      instance_type = "t3.large"
      enable_cloudwatch_agent = true
      enable_load_balancer = true
      enable_auto_scaling_group = true
      enable_vpc_endpoints = true
      
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y nginx
        systemctl start nginx
        systemctl enable nginx
        echo "Custom web server: {instance_name}" > /var/www/html/index.html
      EOF
      
      tags_template = {
        Service = "custom-web"
        Environment = "staging"
        Team = "web-team"
        Instance = "{instance_name}"
      }
      
      security_group_ingress_rules = {
        http = {
          from_port = 80
          to_port = 80
          ip_protocol = "tcp"
          cidr_ipv4 = "0.0.0.0/0"
          description = "HTTP access"
        }
        https = {
          from_port = 443
          to_port = 443
          ip_protocol = "tcp"
          cidr_ipv4 = "0.0.0.0/0"
          description = "HTTPS access"
        }
      }
    }

    custom_api = {
      description = "Custom API server template"
      instance_type = "t3.medium"
      enable_cloudwatch_agent = true
      enable_vpc_endpoints = true
      enable_compliance = true
      
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y nodejs npm
        npm install -g pm2
        echo "API server: {instance_name} ready" > /tmp/ready.txt
      EOF
      
      tags_template = {
        Service = "api"
        Environment = "staging"
        Team = "api-team"
        Instance = "{instance_name}"
      }
      
      security_group_ingress_rules = {
        api = {
          from_port = 8080
          to_port = 8080
          ip_protocol = "tcp"
          cidr_ipv4 = "10.0.0.0/8"
          description = "API access"
        }
      }
    }
  }

  defaults = {
    subnet_id = "subnet-12345678"
    vpc_security_group_ids = ["sg-12345678"]
  }

  instances = {
    # Use custom web template
    custom_web1 = {
      name = "custom-web-1"
      template = "custom_web"
      subnet_id = "subnet-87654321"
      
      load_balancer_config = {
        port = 80
        protocol = "HTTP"
        health_check_path = "/"
        health_check_port = 80
      }
      
      asg_config = {
        min_size = 1
        max_size = 3
        desired_capacity = 1
      }
    }

    # Use custom API template
    custom_api1 = {
      name = "custom-api-1"
      template = "custom_api"
      subnet_id = "subnet-87654322"
      
      cloudwatch_agent_config = {
        create_log_group = true
        log_group_name = "/aws/ec2/custom-api-1"
        log_retention_days = 30
      }
    }
  }
}

# Example 4: Environment-specific deployments
module "ec2_wrapper_production" {
  source = "../"

  name_prefix = "prod-"
  common_tags = {
    Environment = "production"
    Project = "production-project"
    Compliance = "required"
  }

  defaults = {
    instance_type = "t3.large"
    subnet_id = "subnet-prod-12345678"
    vpc_security_group_ids = ["sg-prod-12345678"]
    
    # Production defaults
    enable_enhanced_security = true
    enable_cloudwatch_agent = true
    enable_load_balancer = true
    enable_auto_scaling_group = true
    enable_vpc_endpoints = true
    enable_automated_backups = true
    enable_compliance = true
    enable_advanced_features = true
  }

  instances = {
    prod_web = {
      name = "prod-web-server"
      template = "web_server"
      subnet_id = "subnet-prod-87654321"
      instance_type = "t3.xlarge"
      
      load_balancer_config = {
        port = 80
        protocol = "HTTP"
        health_check_path = "/health"
        health_check_port = 80
        listener_port = 80
        listener_protocol = "HTTP"
      }
      
      asg_config = {
        min_size = 3
        max_size = 10
        desired_capacity = 3
        cooldown = 300
        health_check_grace_period = 300
        enable_scale_in_protection = true
      }
      
      cloudwatch_agent_config = {
        create_log_group = true
        log_group_name = "/aws/ec2/prod-web-server"
        log_retention_days = 90
      }
      
      backup_config = {
        backup_window = "02:00-03:00"
        maintenance_window = "sun:03:00-sun:04:00"
        backup_retention_period = 30
        delete_automated_backups = false
      }
    }
  }
}

# Example 5: Output usage
output "full_featured_outputs" {
  description = "Outputs from full-featured deployment"
  value = {
    instance_ids = module.ec2_wrapper_full.instance_ids
    load_balancer_dns_names = module.ec2_wrapper_full.load_balancer_dns_names
    autoscaling_group_names = module.ec2_wrapper_full.autoscaling_group_names
    cloudwatch_log_group_names = module.ec2_wrapper_full.cloudwatch_log_group_names
    vpc_endpoint_ids = module.ec2_wrapper_full.vpc_endpoint_ids
  }
}

output "minimal_outputs" {
  description = "Outputs from minimal deployment"
  value = {
    instance_ids = module.ec2_wrapper_minimal.instance_ids
    cloudwatch_log_group_names = module.ec2_wrapper_minimal.cloudwatch_log_group_names
  }
}

output "custom_outputs" {
  description = "Outputs from custom template deployment"
  value = {
    instance_ids = module.ec2_wrapper_custom.instance_ids
    load_balancer_dns_names = module.ec2_wrapper_custom.load_balancer_dns_names
    template_usage_summary = module.ec2_wrapper_custom.template_usage_summary
  }
}

output "production_outputs" {
  description = "Outputs from production deployment"
  value = {
    instance_ids = module.ec2_wrapper_production.instance_ids
    load_balancer_dns_names = module.ec2_wrapper_production.load_balancer_dns_names
    autoscaling_group_names = module.ec2_wrapper_production.autoscaling_group_names
    compliance_tags = module.ec2_wrapper_production.compliance_tags
  }
}
