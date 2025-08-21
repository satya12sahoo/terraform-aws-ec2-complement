# =============================================================================
# DYNAMIC TEMPLATES EXAMPLE
# =============================================================================

# Example 1: Using predefined patterns
module "ec2_instances_predefined" {
  source = "../"

  defaults = {
    subnet_id = "subnet-12345678"
    vpc_security_group_ids = ["sg-12345678"]
  }

  instances = {
    # Use predefined web_server pattern
    web1 = {
      name = "web-server-1"
      template = "web_server"
      subnet_id = "subnet-87654321"
    }

    # Use predefined database_server pattern
    db1 = {
      name = "database-server-1"
      template = "database_server"
      subnet_id = "subnet-87654322"
    }

    # Use predefined development_server pattern
    dev1 = {
      name = "dev-server-1"
      template = "development_server"
      subnet_id = "subnet-87654323"
    }
  }
}

# Example 2: Creating custom templates
module "ec2_instances_custom" {
  source = "../"

  # Define custom templates
  templates = {
    # Custom web server template
    custom_web = {
      description = "Custom web server with specific requirements"
      instance_type = "t3.large"
      enable_cloudwatch_agent = true
      enable_load_balancer = true
      enable_auto_scaling_group = true
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
        Environment = "production"
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
        custom_app = {
          from_port = 3000
          to_port = 3000
          ip_protocol = "tcp"
          cidr_ipv4 = "10.0.0.0/8"
          description = "Custom application port"
        }
      }
    }

    # Custom API server template
    custom_api = {
      description = "Custom API server with monitoring"
      instance_type = "t3.medium"
      enable_cloudwatch_agent = true
      detailed_monitoring = true
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
        Environment = "production"
        Team = "api-team"
        Instance = "{instance_name}"
        Monitoring = "enabled"
      }
      security_group_ingress_rules = {
        api = {
          from_port = 8080
          to_port = 8080
          ip_protocol = "tcp"
          cidr_ipv4 = "10.0.0.0/8"
          description = "API access"
        }
        health = {
          from_port = 3000
          to_port = 3000
          ip_protocol = "tcp"
          cidr_ipv4 = "10.0.0.0/8"
          description = "Health check"
        }
      }
      ebs_volumes = {
        app_data = {
          size = 50
          type = "gp3"
          encrypted = true
          device_name = "/dev/sdf"
        }
      }
    }

    # Custom microservice template
    custom_microservice = {
      description = "Microservice with container support"
      instance_type = "t3.small"
      enable_cloudwatch_agent = true
      enable_scheduling = true
      enable_cost_optimization = true
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y docker
        systemctl start docker
        systemctl enable docker
        docker run -d --name {instance_name} nginx:alpine
      EOF
      tags_template = {
        Service = "microservice"
        Environment = "production"
        Team = "devops"
        Instance = "{instance_name}"
        Containerized = "true"
      }
      security_group_ingress_rules = {
        app = {
          from_port = 80
          to_port = 80
          ip_protocol = "tcp"
          cidr_ipv4 = "10.0.0.0/8"
          description = "Application access"
        }
      }
    }

    # Custom data processing template
    custom_data_processing = {
      description = "Data processing server with high storage"
      instance_type = "c5.large"
      enable_cloudwatch_agent = true
      detailed_monitoring = true
      enable_automated_backups = true
      enable_vpc_endpoints = true
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y python3 python3-pip
        pip3 install pandas numpy scikit-learn
        echo "Data processing server: {instance_name} ready" > /tmp/ready.txt
      EOF
      tags_template = {
        Service = "data-processing"
        Environment = "production"
        Team = "data-team"
        Instance = "{instance_name}"
        DataClass = "sensitive"
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
      ebs_volumes = {
        data = {
          size = 500
          type = "gp3"
          encrypted = true
          device_name = "/dev/sdf"
        }
        cache = {
          size = 100
          type = "io2"
          encrypted = true
          device_name = "/dev/sdg"
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
    }

    # Use custom API template
    custom_api1 = {
      name = "custom-api-1"
      template = "custom_api"
      subnet_id = "subnet-87654322"
    }

    # Use custom microservice template
    custom_ms1 = {
      name = "custom-ms-1"
      template = "custom_microservice"
      subnet_id = "subnet-87654323"
    }

    # Use custom data processing template
    custom_dp1 = {
      name = "custom-dp-1"
      template = "custom_data_processing"
      subnet_id = "subnet-87654324"
    }
  }
}

# Example 3: Template with pattern inheritance
module "ec2_instances_inheritance" {
  source = "../"

  templates = {
    # Inherit from web_server pattern but customize
    enhanced_web = {
      description = "Enhanced web server based on web_server pattern"
      pattern = "web_server"  # Inherit from predefined pattern
      instance_type = "t3.xlarge"  # Override instance type
      enable_advanced_features = true  # Add advanced features
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd mod_ssl
        systemctl start httpd
        systemctl enable httpd
        echo "Enhanced web server: {instance_name}" > /var/www/html/index.html
        # Additional security hardening
        sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/httpd/conf/httpd.conf
        systemctl restart httpd
      EOF
      tags_template = {
        Service = "enhanced-web"
        Environment = "production"
        Security = "hardened"
        Instance = "{instance_name}"
      }
    }

    # Inherit from database_server pattern but customize
    enhanced_db = {
      description = "Enhanced database server based on database_server pattern"
      pattern = "database_server"  # Inherit from predefined pattern
      instance_type = "r5.large"  # Use R5 for better memory
      enable_automated_backups = true
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y mysql-server mysql-client
        systemctl start mysqld
        systemctl enable mysqld
        # Additional database configuration
        mysql_secure_installation <<EOF
        y
        y
        y
        y
        y
        y
        EOF
        echo "Enhanced database server: {instance_name} ready" > /tmp/ready.txt
      EOF
      tags_template = {
        Service = "enhanced-database"
        Environment = "production"
        Backup = "automated"
        Instance = "{instance_name}"
      }
    }
  }

  defaults = {
    subnet_id = "subnet-12345678"
    vpc_security_group_ids = ["sg-12345678"]
  }

  instances = {
    enhanced_web1 = {
      name = "enhanced-web-1"
      template = "enhanced_web"
      subnet_id = "subnet-87654321"
    }

    enhanced_db1 = {
      name = "enhanced-db-1"
      template = "enhanced_db"
      subnet_id = "subnet-87654322"
    }
  }
}

# Example 4: Environment-specific templates
module "ec2_instances_environment" {
  source = "../"

  templates = {
    # Production web server template
    prod_web = {
      description = "Production web server template"
      instance_type = "t3.large"
      enable_cloudwatch_agent = true
      enable_load_balancer = true
      enable_auto_scaling_group = true
      enable_vpc_endpoints = true
      enable_compliance = true
      enable_automated_backups = true
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo "Production web server: {instance_name}" > /var/www/html/index.html
      EOF
      tags_template = {
        Service = "web"
        Environment = "production"
        Backup = "daily"
        Compliance = "required"
        Instance = "{instance_name}"
      }
    }

    # Staging web server template
    staging_web = {
      description = "Staging web server template"
      instance_type = "t3.medium"
      enable_cloudwatch_agent = true
      enable_load_balancer = true
      enable_scheduling = true
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo "Staging web server: {instance_name}" > /var/www/html/index.html
      EOF
      tags_template = {
        Service = "web"
        Environment = "staging"
        Backup = "weekly"
        Instance = "{instance_name}"
      }
    }

    # Development web server template
    dev_web = {
      description = "Development web server template"
      instance_type = "t3.small"
      enable_cloudwatch_agent = true
      enable_scheduling = true
      enable_cost_optimization = true
      user_data_template = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo "Development web server: {instance_name}" > /var/www/html/index.html
      EOF
      tags_template = {
        Service = "web"
        Environment = "development"
        Backup = "none"
        Instance = "{instance_name}"
      }
    }
  }

  defaults = {
    subnet_id = "subnet-12345678"
    vpc_security_group_ids = ["sg-12345678"]
  }

  instances = {
    prod_web1 = {
      name = "prod-web-1"
      template = "prod_web"
      subnet_id = "subnet-87654321"
    }

    staging_web1 = {
      name = "staging-web-1"
      template = "staging_web"
      subnet_id = "subnet-87654322"
    }

    dev_web1 = {
      name = "dev-web-1"
      template = "dev_web"
      subnet_id = "subnet-87654323"
    }
  }
}
