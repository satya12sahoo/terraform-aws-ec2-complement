# =============================================================================
# DYNAMIC TEMPLATES - Template Creation Based on User Input
# =============================================================================

# Template definition variable - allows users to define custom templates
variable "templates" {
  description = "Map of custom templates that can be referenced by instances"
  type = map(object({
    description = optional(string, "Custom template")
    
    # Template configuration
    instance_type = optional(string, "t3.micro")
    ami_ssm_parameter = optional(string, "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64")
    
    # Security configuration
    enable_enhanced_security = optional(bool, true)
    enable_imdsv2 = optional(bool, true)
    enable_encryption_by_default = optional(bool, true)
    enable_security_hardening = optional(bool, false)
    
    # Monitoring configuration
    enable_cloudwatch_agent = optional(bool, false)
    detailed_monitoring = optional(bool, false)
    
    # Cost optimization
    enable_scheduling = optional(bool, false)
    enable_cost_optimization = optional(bool, false)
    
    # Backup configuration
    enable_automated_backups = optional(bool, false)
    
    # Network configuration
    enable_vpc_endpoints = optional(bool, false)
    enable_load_balancer = optional(bool, false)
    enable_auto_scaling_group = optional(bool, false)
    
    # Compliance configuration
    enable_compliance = optional(bool, false)
    
    # Advanced features
    enable_advanced_features = optional(bool, false)
    
    # User data template
    user_data_template = optional(string)
    
    # Tags template
    tags_template = optional(map(string), {})
    
    # Security groups template
    security_group_ingress_rules = optional(map(object({
      cidr_ipv4 = optional(string)
      cidr_ipv6 = optional(string)
      description = optional(string)
      from_port = optional(number)
      ip_protocol = optional(string, "tcp")
      to_port = optional(number)
    })), {})
    
    # EBS volumes template
    ebs_volumes = optional(map(object({
      size = optional(number, 20)
      type = optional(string, "gp3")
      encrypted = optional(bool, true)
      device_name = optional(string)
    })), {})
  }))
  default = {}
}

# Template factory - creates templates based on patterns
locals {
  # Template factory function
  create_template = function(pattern, config) {
    base_config = {
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
      user_data_template = null
      tags_template = {}
      security_group_ingress_rules = {}
      ebs_volumes = {}
    }
    
    # Pattern-based configurations
    pattern_configs = {
      # Web Server Pattern
      "web_server" = merge(base_config, {
        instance_type = "t3.medium"
        enable_cloudwatch_agent = true
        enable_load_balancer = true
        enable_auto_scaling_group = true
        enable_vpc_endpoints = true
        enable_compliance = true
        user_data_template = <<-EOF
          #!/bin/bash
          yum update -y
          yum install -y httpd
          systemctl start httpd
          systemctl enable httpd
          echo "<h1>Hello from Web Server</h1>" > /var/www/html/index.html
        EOF
        tags_template = {
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
      
      # Database Server Pattern
      "database_server" = merge(base_config, {
        instance_type = "t3.large"
        enable_cloudwatch_agent = true
        detailed_monitoring = true
        enable_automated_backups = true
        enable_vpc_endpoints = true
        enable_compliance = true
        user_data_template = <<-EOF
          #!/bin/bash
          yum update -y
          yum install -y mysql-server
          systemctl start mysqld
          systemctl enable mysqld
        EOF
        tags_template = {
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
            device_name = "/dev/sdf"
          }
        }
      })
      
      # Application Server Pattern
      "application_server" = merge(base_config, {
        instance_type = "t3.medium"
        enable_cloudwatch_agent = true
        enable_scheduling = true
        enable_cost_optimization = true
        enable_vpc_endpoints = true
        user_data_template = <<-EOF
          #!/bin/bash
          yum update -y
          yum install -y java-11-openjdk
          yum install -y tomcat
          systemctl start tomcat
          systemctl enable tomcat
        EOF
        tags_template = {
          Service = "application"
          Environment = "production"
          Backup = "weekly"
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
      
      # Development Server Pattern
      "development_server" = merge(base_config, {
        instance_type = "t3.small"
        enable_enhanced_security = false
        enable_cloudwatch_agent = true
        enable_scheduling = true
        enable_cost_optimization = true
        user_data_template = <<-EOF
          #!/bin/bash
          yum update -y
          yum install -y git docker
          systemctl start docker
          systemctl enable docker
        EOF
        tags_template = {
          Service = "development"
          Environment = "development"
          Backup = "none"
        }
        security_group_ingress_rules = {
          ssh = {
            from_port = 22
            to_port = 22
            ip_protocol = "tcp"
            cidr_ipv4 = "10.0.0.0/8"
            description = "SSH access"
          }
        }
      })
      
      # Bastion Host Pattern
      "bastion_host" = merge(base_config, {
        instance_type = "t3.micro"
        enable_security_hardening = true
        enable_cloudwatch_agent = true
        enable_vpc_endpoints = true
        enable_compliance = true
        user_data_template = <<-EOF
          #!/bin/bash
          yum update -y
          yum install -y fail2ban
          systemctl start fail2ban
          systemctl enable fail2ban
        EOF
        tags_template = {
          Service = "bastion"
          Environment = "production"
          Backup = "none"
          Security = "high"
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
      
      # High Performance Pattern
      "high_performance" = merge(base_config, {
        instance_type = "c5.large"
        enable_cloudwatch_agent = true
        detailed_monitoring = true
        enable_load_balancer = true
        enable_auto_scaling_group = true
        enable_vpc_endpoints = true
        enable_advanced_features = true
        user_data_template = <<-EOF
          #!/bin/bash
          yum update -y
          yum install -y nginx
          systemctl start nginx
          systemctl enable nginx
          echo "server { listen 80; location / { return 200 'OK'; } }" > /etc/nginx/conf.d/health.conf
        EOF
        tags_template = {
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
    }
    
    # Merge base config with pattern config and user config
    pattern_config = lookup(pattern_configs, pattern, base_config)
    final_config = merge(pattern_config, config)
    
    final_config
  }
  
  # Generate templates from user input
  generated_templates = {
    for name, config in var.templates : name => local.create_template(
      lookup(config, "pattern", "custom"),
      config
    )
  }
  
  # Combine predefined patterns with user-defined templates
  all_templates = merge(local.generated_templates, {
    # Predefined patterns (for backward compatibility)
    web_server = local.create_template("web_server", {})
    database_server = local.create_template("database_server", {})
    application_server = local.create_template("application_server", {})
    development_server = local.create_template("development_server", {})
    bastion_host = local.create_template("bastion_host", {})
    high_performance = local.create_template("high_performance", {})
  })
}

# Template application with variable substitution
locals {
  # Function to apply template with variable substitution
  apply_template_with_vars = function(instance_config, template_name, variables) {
    template = local.all_templates[template_name]
    
    # Variable substitution in user_data_template
    user_data = template.user_data_template != null ? replace(
      template.user_data_template,
      "{instance_name}", coalesce(instance_config.name, "unknown")
    ) : null
    
    # Variable substitution in tags
    tags = merge(
      template.tags_template,
      {
        for k, v in template.tags_template : k => replace(v, "{instance_name}", coalesce(instance_config.name, "unknown"))
      }
    )
    
    # Merge template with instance config and apply substitutions
    merged_config = merge(template, instance_config)
    
    # Apply substitutions
    merge(merged_config, {
      user_data = user_data
      tags = merge(merged_config.tags, tags)
    })
  }
  
  # Apply templates to instances
  instances_with_templates = {
    for key, config in local.merged_instances : key => (
      can(config.template) && config.template != null
      ? local.apply_template_with_vars(config, config.template, {})
      : config
    )
  }
  
  # Final merged instances with templates applied
  final_instances = local.instances_with_templates
}
