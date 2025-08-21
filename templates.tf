# =============================================================================
# TEMPLATE SYSTEM
# =============================================================================
#
# This file provides a simplified template system for common EC2 instance patterns.
# Templates can be applied to instances by specifying the template name in the
# instance configuration.
#
# Available templates:
# - web_server: Basic web server configuration
# - database_server: Database server configuration
# - application_server: Application server configuration
# - development_server: Development server configuration
# - bastion_host: Bastion host configuration
# - high_performance: High-performance server configuration
#
# =============================================================================

# Predefined templates
locals {
  # Base configuration for all templates
  base_template = {
    instance_type = "t3.micro"
    enable_enhanced_security = true
    enable_imdsv2 = true
    enable_encryption_by_default = true
    enable_cloudwatch_agent = false
    detailed_monitoring = false
    enable_scheduling = false
    enable_cost_optimization = false
    enable_automated_backups = false
    enable_vpc_endpoints = false
    enable_load_balancer = false
    enable_auto_scaling_group = false
    enable_compliance = false
    enable_advanced_features = false
    user_data = null
    tags = {}
    security_group_ingress_rules = {}
    ebs_volumes = {}
  }

  # Web Server Template
  web_server_template = merge(local.base_template, {
    instance_type = "t3.medium"
    enable_cloudwatch_agent = true
    enable_load_balancer = true
    enable_auto_scaling_group = true
    enable_vpc_endpoints = true
    enable_compliance = true
    user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
      echo "<h1>Hello from Web Server</h1>" > /var/www/html/index.html
    EOF
    tags = {
      Service = "web"
      Environment = "production"
      Backup = "daily"
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
  })

  # Database Server Template
  database_server_template = merge(local.base_template, {
    instance_type = "t3.large"
    enable_cloudwatch_agent = true
    detailed_monitoring = true
    enable_automated_backups = true
    enable_vpc_endpoints = true
    enable_compliance = true
    user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y mysql-server
      systemctl start mysqld
      systemctl enable mysqld
    EOF
    tags = {
      Service = "database"
      Environment = "production"
      Backup = "daily"
      Encryption = "required"
    }
    security_group_ingress_rules = {
      mysql = {
        from_port = 3306
        to_port = 3306
        ip_protocol = "tcp"
        cidr_ipv4 = "10.0.0.0/8"
        description = "MySQL access"
      }
    }
    ebs_volumes = {
      data = {
        size = 100
        type = "gp3"
        encrypted = true
        delete_on_termination = false
      }
    }
  })

  # Application Server Template
  application_server_template = merge(local.base_template, {
    instance_type = "t3.medium"
    enable_cloudwatch_agent = true
    enable_load_balancer = true
    enable_auto_scaling_group = true
    enable_vpc_endpoints = true
    user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y java-11-openjdk
      yum install -y nginx
      systemctl start nginx
      systemctl enable nginx
    EOF
    tags = {
      Service = "application"
      Environment = "production"
      Backup = "daily"
    }
    security_group_ingress_rules = {
      app = {
        from_port = 8080
        to_port = 8080
        ip_protocol = "tcp"
        cidr_ipv4 = "10.0.0.0/8"
        description = "Application access"
      }
    }
  })

  # Development Server Template
  development_server_template = merge(local.base_template, {
    instance_type = "t3.small"
    enable_cloudwatch_agent = false
    enable_cost_optimization = true
    user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y git docker
      systemctl start docker
      systemctl enable docker
    EOF
    tags = {
      Service = "development"
      Environment = "development"
      Backup = "none"
    }
    security_group_ingress_rules = {
      ssh = {
        from_port = 22
        to_port = 22
        ip_protocol = "tcp"
        cidr_ipv4 = "0.0.0.0/0"
        description = "SSH access"
      }
    }
  })

  # Bastion Host Template
  bastion_host_template = merge(local.base_template, {
    instance_type = "t3.nano"
    enable_enhanced_security = true
    enable_imdsv2 = true
    enable_compliance = true
    user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y fail2ban
      systemctl start fail2ban
      systemctl enable fail2ban
    EOF
    tags = {
      Service = "bastion"
      Environment = "production"
      Backup = "none"
      Security = "critical"
    }
    security_group_ingress_rules = {
      ssh = {
        from_port = 22
        to_port = 22
        ip_protocol = "tcp"
        cidr_ipv4 = "0.0.0.0/0"
        description = "SSH access"
      }
    }
  })

  # High Performance Template
  high_performance_template = merge(local.base_template, {
    instance_type = "c5.large"
    enable_cloudwatch_agent = true
    detailed_monitoring = true
    enable_load_balancer = true
    enable_auto_scaling_group = true
    enable_vpc_endpoints = true
    enable_compliance = true
    user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y nginx
      systemctl start nginx
      systemctl enable nginx
      echo "server { listen 80; location / { return 200 'OK'; } }" > /etc/nginx/conf.d/health.conf
    EOF
    tags = {
      Service = "high-performance"
      Environment = "production"
      Backup = "daily"
      Performance = "optimized"
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
  })

  # All available templates
  available_templates = {
    web_server = local.web_server_template
    database_server = local.database_server_template
    application_server = local.application_server_template
    development_server = local.development_server_template
    bastion_host = local.bastion_host_template
    high_performance = local.high_performance_template
  }

  # Apply templates to instances
  instances_with_templates = {
    for key, config in local.merged_instances : key => (
      can(config.template) && config.template != null && contains(keys(local.available_templates), config.template)
      ? merge(local.available_templates[config.template], config)
      : config
    )
  }

  # Final merged instances with templates applied
  final_instances = local.instances_with_templates
}
