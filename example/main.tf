# Example usage of the terraform-aws-ec2-instance-wrapper module

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Example: Multiple EC2 Instances
module "ec2_instances" {
  source = "../"

  # Default configuration that applies to all instances
  defaults = {
    # Common instance configuration
    instance_type = "t3.micro"
    ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
    
    # Common tags for all instances
    tags = {
      Environment = "dev"
      Project     = "example"
      ManagedBy   = "terraform"
    }
    
    # Common security group configuration
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
    
    # Common metadata options
    metadata_options = {
      http_endpoint               = "enabled"
      http_put_response_hop_limit = 1
      http_tokens                 = "required"
    }
    
    # IAM Configuration - Use existing IAM role by default
    create_iam_instance_profile = false  # Don't create new IAM profile
    iam_instance_profile = "existing-ec2-role"  # Use existing IAM role name
  }

  # Individual instance configurations (can override defaults)
  instances = {
    # Basic instance - uses all defaults including existing IAM role
    basic = {
      name = "basic-instance"
      subnet_id = "subnet-12345678"
    }

    # Web server - overrides some defaults
    web_server = {
      name = "web-server"
      instance_type = "t3.small"  # Override default instance type
      subnet_id = "subnet-12345678"
      
      # Override security group rules for web server
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
      
      # Add instance-specific tags
      tags = {
        Environment = "prod"  # Override default environment
        Role        = "web-server"
        Project     = "example"
        ManagedBy   = "terraform"
      }
      
      # Enable EIP for web server
      create_eip = true
    }

    # App server - different configuration
    app_server = {
      name = "app-server"
      instance_type = "t3.medium"  # Override default instance type
      subnet_id = "subnet-12345678"
      
      # Custom security group rules for app server
      security_group_ingress_rules = {
        app_port = {
          from_port   = 8080
          to_port     = 8080
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "Application port access"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
      
      # Add EBS volume for app data
      ebs_volumes = {
        app_data = {
          size = 100
          type = "gp3"
          encrypted = true
          tags = {
            Name = "app-data"
          }
        }
      }
      
      # Instance-specific tags
      tags = {
        Environment = "prod"
        Role        = "app-server"
        Project     = "example"
        ManagedBy   = "terraform"
      }
    }

    # Database server - different configuration
    db_server = {
      name = "db-server"
      instance_type = "t3.large"  # Override default instance type
      subnet_id = "subnet-12345678"
      
      # Minimal security group for database
      security_group_ingress_rules = {
        db_port = {
          from_port   = 5432
          to_port     = 5432
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "Database access"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
      
      # Add EBS volume for database
      ebs_volumes = {
        db_data = {
          size = 200
          type = "gp3"
          encrypted = true
          tags = {
            Name = "db-data"
          }
        }
      }
      
      # Instance-specific tags
      tags = {
        Environment = "prod"
        Role        = "database"
        Project     = "example"
        ManagedBy   = "terraform"
      }
    }

    # Spot instance - uses defaults but with spot configuration
    spot_worker = {
      name = "spot-worker"
      subnet_id = "subnet-12345678"
      
      # Override to create spot instance
      create_spot_instance = true
      spot_price = "0.01"
      
      # Instance-specific tags
      tags = {
        Environment = "dev"
        InstanceType = "spot"
        Project     = "example"
        ManagedBy   = "terraform"
      }
    }
    
    # Instance with custom IAM role - overrides default IAM role
    custom_role_instance = {
      name = "custom-role-instance"
      instance_type = "t3.small"
      subnet_id = "subnet-12345678"
      
      # Override to use a different existing IAM role
      create_iam_instance_profile = false
      iam_instance_profile = "custom-ec2-role"  # Different existing IAM role
      
      tags = {
        Environment = "prod"
        Role        = "custom-role"
        Project     = "example"
        ManagedBy   = "terraform"
      }
    }
    
    # Instance that creates its own IAM role - overrides default
    new_role_instance = {
      name = "new-role-instance"
      instance_type = "t3.small"
      subnet_id = "subnet-12345678"
      
      # Override to create a new IAM role for this instance
      create_iam_instance_profile = true
      iam_role_name = "new-instance-role"
      iam_role_policies = {
        s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
        cloudwatch_agent = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }
      iam_role_tags = {
        Name = "new-instance-role"
        Purpose = "Custom EC2 role"
      }
      
      tags = {
        Environment = "prod"
        Role        = "new-role"
        Project     = "example"
        ManagedBy   = "terraform"
      }
    }
  }
}
