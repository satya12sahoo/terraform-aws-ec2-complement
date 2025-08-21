# Example: Using Existing IAM Roles with EC2 Instance Wrapper
# This example shows how to use existing IAM roles and create instance profiles for them

module "ec2_instances_with_existing_iam" {
  source = "../"

  # Default configuration using existing IAM role
  defaults = {
    instance_type = "t3.micro"
    ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
    
    # Use existing IAM role and create instance profile for it
    create_iam_instance_profile = false
    create_instance_profile_for_existing_role = true  # Create instance profile for existing role
    iam_instance_profile = "existing-ec2-role"  # Your existing IAM role name
    instance_profile_name = "existing-ec2-role-profile"  # Name for the instance profile
    
    # Common tags
    tags = {
      Environment = "prod"
      Project     = "example"
      ManagedBy   = "terraform"
    }
    
    # Common security group
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
  }

  instances = {
    # Instance using default existing IAM role with created instance profile
    web_server = {
      name = "web-server"
      subnet_id = "subnet-12345678"
      
      # Additional security group rules for web server
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
      
      tags = {
        Environment = "prod"
        Role        = "web-server"
        Project     = "example"
        ManagedBy   = "terraform"
      }
      
      create_eip = true
    }
    
    # Instance using different existing IAM role with custom instance profile
    app_server = {
      name = "app-server"
      instance_type = "t3.small"
      subnet_id = "subnet-12345678"
      
      # Override to use different existing IAM role and create instance profile
      create_instance_profile_for_existing_role = true
      iam_instance_profile = "app-server-role"  # Different existing IAM role
      instance_profile_name = "app-server-role-profile"  # Custom instance profile name
      instance_profile_tags = {
        Purpose = "App server instance profile"
        Role    = "app-server"
      }
      
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
      
      tags = {
        Environment = "prod"
        Role        = "app-server"
        Project     = "example"
        ManagedBy   = "terraform"
      }
    }
    
    # Instance with no IAM role (overrides default)
    no_role_instance = {
      name = "no-role-instance"
      subnet_id = "subnet-12345678"
      
      # Override to not use any IAM role
      create_iam_instance_profile = false
      create_instance_profile_for_existing_role = false
      # Don't specify iam_instance_profile
      
      tags = {
        Environment = "prod"
        Role        = "no-role"
        Project     = "example"
        ManagedBy   = "terraform"
      }
    }
    
    # Instance that creates its own IAM role (overrides default)
    new_role_instance = {
      name = "new-role-instance"
      instance_type = "t3.small"
      subnet_id = "subnet-12345678"
      
      # Override to create a new IAM role for this instance
      create_iam_instance_profile = true
      create_instance_profile_for_existing_role = false  # Don't create instance profile for existing role
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

# Outputs for the instances using existing IAM roles
output "web_server_public_ip" {
  description = "Public IP of web server"
  value       = module.ec2_instances_with_existing_iam.public_ips["web_server"]
}

output "app_server_public_ip" {
  description = "Public IP of app server"
  value       = module.ec2_instances_with_existing_iam.public_ips["app_server"]
}

output "all_instance_ids" {
  description = "All instance IDs"
  value       = module.ec2_instances_with_existing_iam.instance_ids
}

# Outputs for instance profiles created for existing IAM roles
output "instance_profile_names" {
  description = "Names of instance profiles created for existing IAM roles"
  value       = module.ec2_instances_with_existing_iam.existing_role_instance_profile_names
}

output "instance_profile_arns" {
  description = "ARNs of instance profiles created for existing IAM roles"
  value       = module.ec2_instances_with_existing_iam.existing_role_instance_profile_arns
}
