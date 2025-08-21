# Terraform AWS EC2 Instance Wrapper Module

This is a wrapper module for the [terraform-aws-ec2-instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance) module. It provides the same functionality as the original module but can be used as a child module in your Terraform configurations with support for creating multiple instances and default configurations.

## Features

This wrapper module provides all the features of the original terraform-aws-ec2-instance module:

- **Multiple EC2 Instances**: Create and manage multiple EC2 instances with a single module call
- **Default Configurations**: Set common defaults that apply to all instances
- **Instance Overrides**: Individual instances can override any default values
- **EC2 Instance Management**: Create and manage EC2 instances with full configuration options
- **Spot Instances**: Support for spot instance requests
- **Security Groups**: Automatic security group creation with customizable rules
- **IAM Roles**: IAM role and instance profile creation
- **EBS Volumes**: Additional EBS volume attachment
- **Elastic IPs**: Automatic EIP creation and association
- **Multiple Instance Types**: Support for regular instances, instances with AMI changes ignored, and spot instances

### Enhanced Features (NEW)

- **Conditional Instance Creation**: Enable/disable individual instances with the `enabled` toggle
- **Enhanced Security**: Advanced security features with toggles for IMDSv2, encryption, and security hardening
- **Monitoring & Observability**: CloudWatch agent integration with automatic log group creation or use existing ones
- **Cost Optimization**: Instance scheduling, spot instances, and auto-scaling for cost savings
- **Backup & Disaster Recovery**: Automated backups with cross-region support
- **Network & Connectivity**: VPC endpoints and load balancer integration
- **Compliance & Governance**: Tag enforcement, audit logging, and compliance policies
- **Performance & Scaling**: Auto Scaling Groups with health checks and scaling policies
- **Advanced Features**: SSM automation, patch management, and maintenance windows

## Enhanced Features Configuration

The wrapper module includes advanced features that can be toggled on/off for each instance:

### 1. Conditional Instance Creation

Enable or disable individual instances:

```hcl
instances = {
  enabled_instance = {
    name = "enabled-instance"
    subnet_id = "subnet-12345678"
    enabled = true  # Instance will be created
  }
  
  disabled_instance = {
    name = "disabled-instance"
    subnet_id = "subnet-12345678"
    enabled = false  # Instance will NOT be created
  }
}
```

### 2. Enhanced Security Features

Advanced security configurations with toggles:

```hcl
defaults = {
  # Enhanced security defaults
  enable_enhanced_security = true
  enable_imdsv2 = true  # Require IMDSv2
  enable_encryption_by_default = true  # Encrypt EBS volumes
  enable_security_hardening = false  # Enable security hardening
  
  security_hardening_config = {
    disable_password_auth = true
    enable_selinux = true
    enable_audit_logging = true
  }
}
```

### 3. Monitoring & Observability

CloudWatch integration with automatic log group creation:

```hcl
defaults = {
  # Monitoring defaults
  enable_cloudwatch_agent = false
  cloudwatch_agent_config = {
    metrics_collection_interval = 60
    log_group_name = null  # Auto-generated: /aws/ec2/{instance-name}
    log_stream_name = null  # Auto-generated
    create_log_group = true  # Create new log group or use existing
    log_retention_days = 30
    enable_structured_logging = false
    enable_xray_tracing = false
  }
  detailed_monitoring = false
}

instances = {
  monitored_instance = {
    name = "monitored-instance"
    subnet_id = "subnet-12345678"
    
    # Override monitoring for this instance
    enable_cloudwatch_agent = true
    cloudwatch_agent_config = {
      log_group_name = "/aws/ec2/custom-log-group"  # Use existing log group
      create_log_group = false  # Don't create, use existing
      log_retention_days = 90
      enable_structured_logging = true
    }
    detailed_monitoring = true
  }
}
```

### 4. Cost Optimization Features

Instance scheduling and cost optimization:

```hcl
defaults = {
  # Cost optimization defaults
  enable_scheduling = false
  schedule_config = {
    start_time = "09:00"
    stop_time = "18:00"
    timezone = "UTC"
    days_of_week = ["monday", "tuesday", "wednesday", "thursday", "friday"]
  }
  enable_cost_optimization = false
  cost_optimization_config = {
    enable_spot_instances = false
    enable_auto_scaling = false
    enable_rightsizing = false
  }
}

instances = {
  scheduled_instance = {
    name = "scheduled-instance"
    subnet_id = "subnet-12345678"
    
    # Enable scheduling for cost savings
    enable_scheduling = true
    schedule_config = {
      start_time = "08:00"
      stop_time = "20:00"
      timezone = "UTC"
      days_of_week = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    }
  }
}
```

### 5. Backup & Disaster Recovery

Automated backups with cross-region support:

```hcl
defaults = {
  # Backup defaults
  enable_automated_backups = false
  backup_config = {
    retention_days = 7
    backup_window = "03:00-04:00"
    maintenance_window = "sun:04:00-sun:05:00"
    copy_tags_to_snapshot = true
    enable_cross_region_backup = false
    backup_region = null
  }
}

instances = {
  backed_up_instance = {
    name = "backed-up-instance"
    subnet_id = "subnet-12345678"
    
    # Enable automated backups
    enable_automated_backups = true
    backup_config = {
      retention_days = 30
      backup_window = "02:00-03:00"
      maintenance_window = "sun:03:00-sun:04:00"
      copy_tags_to_snapshot = true
      enable_cross_region_backup = true
      backup_region = "us-west-2"
    }
  }
}
```

### 6. Network & Connectivity

VPC endpoints and load balancer integration:

```hcl
defaults = {
  # Network defaults
  enable_vpc_endpoints = false
  vpc_endpoints = [
    "com.amazonaws.region.ec2",
    "com.amazonaws.region.ssm",
    "com.amazonaws.region.ssmmessages"
  ]
  enable_load_balancer = false
  load_balancer_config = {
    target_group_arn = null  # Auto-created
    port = 80
    protocol = "HTTP"
    health_check_path = "/"
    health_check_port = 80
    health_check_protocol = "HTTP"
  }
}

instances = {
  load_balanced_instance = {
    name = "load-balanced-instance"
    subnet_id = "subnet-12345678"
    
    # Enable VPC endpoints and load balancer
    enable_vpc_endpoints = true
    vpc_endpoints = [
      "com.amazonaws.region.ec2",
      "com.amazonaws.region.ssm",
      "com.amazonaws.region.ssmmessages",
      "com.amazonaws.region.s3"
    ]
    enable_load_balancer = true
    load_balancer_config = {
      port = 80
      protocol = "HTTP"
      health_check_path = "/health"
      health_check_port = 80
      health_check_protocol = "HTTP"
    }
  }
}
```

### 7. Compliance & Governance

Tag enforcement and compliance policies:

```hcl
defaults = {
  # Compliance defaults
  enable_compliance = false
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
}

instances = {
  compliant_instance = {
    name = "compliant-instance"
    subnet_id = "subnet-12345678"
    
    # Enable compliance features
    enable_compliance = true
    compliance_config = {
      required_tags = {
        Environment = "prod"
        Project = "production-app"
        Owner = "devops-team"
        CostCenter = "production-infrastructure"
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
  }
}
```

### 8. Performance & Scaling

Auto Scaling Groups with health checks:

```hcl
defaults = {
  # Auto scaling defaults
  enable_auto_scaling_group = false
  asg_config = {
    min_size = 1
    max_size = 3
    desired_capacity = 1
    health_check_type = "EC2"
    health_check_grace_period = 300
    cooldown = 300
    enable_scale_in_protection = false
  }
}

instances = {
  auto_scaled_instance = {
    name = "auto-scaled-instance"
    subnet_id = "subnet-12345678"
    
    # Enable auto scaling
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
  }
}
```

### 9. Advanced Features

SSM automation and management features:

```hcl
defaults = {
  # Advanced features defaults
  enable_advanced_features = false
  advanced_features_config = {
    enable_ssm_automation = false
    enable_patch_management = false
    enable_inventory_management = false
    enable_maintenance_windows = false
  }
}

instances = {
  advanced_instance = {
    name = "advanced-instance"
    subnet_id = "subnet-12345678"
    
    # Enable advanced features
    enable_advanced_features = true
    advanced_features_config = {
      enable_ssm_automation = true
      enable_patch_management = true
      enable_inventory_management = true
      enable_maintenance_windows = true
    }
  }
}
```

## IAM Role Configuration

The wrapper module provides flexible IAM role configuration options:

### Understanding IAM Roles vs Instance Profiles

- **IAM Role**: Defines permissions (policies) that can be assumed by AWS services
- **IAM Instance Profile**: A container for an IAM role that can be attached to EC2 instances

**Important**: You cannot directly attach an IAM role to an EC2 instance. You need an instance profile that contains the IAM role.

### Option 1: Use Existing IAM Role (Recommended for existing infrastructure)

If you already have an IAM role that you want to use:

```hcl
defaults = {
  create_iam_instance_profile = false  # Don't create new IAM profile
  iam_instance_profile = "existing-ec2-role"  # Use existing IAM role name
}
```

**Note**: If your existing IAM role doesn't have an instance profile, you can create one:

```hcl
defaults = {
  create_iam_instance_profile = false
  create_instance_profile_for_existing_role = true  # Create instance profile for existing role
  iam_instance_profile = "existing-ec2-role"  # Your existing IAM role name
  instance_profile_name = "existing-ec2-role-profile"  # Name for the instance profile
}
```

### Option 2: Create New IAM Role

If you want the module to create a new IAM role:

```hcl
defaults = {
  create_iam_instance_profile = true
  iam_role_name = "new-ec2-role"
  iam_role_policies = {
    s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    cloudwatch_agent = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }
}
```

### Option 3: No IAM Role

If you don't want any IAM role:

```hcl
defaults = {
  create_iam_instance_profile = false
  # Don't specify iam_instance_profile
}
```

### Individual Instance Overrides

Each instance can override the default IAM configuration:

```hcl
instances = {
  # Uses default IAM configuration
  basic = {
    name = "basic-instance"
    subnet_id = "subnet-12345678"
  }
  
  # Uses different existing IAM role
  custom = {
    name = "custom-instance"
    subnet_id = "subnet-12345678"
    iam_instance_profile = "custom-ec2-role"
  }
  
  # Creates its own IAM role
  new_role = {
    name = "new-role-instance"
    subnet_id = "subnet-12345678"
    create_iam_instance_profile = true
    iam_role_name = "instance-specific-role"
    iam_role_policies = {
      s3_full_access = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    }
  }
}
```

## Usage

### Basic Usage with Defaults

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  # Default configuration that applies to all instances
  defaults = {
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
  }

  # Individual instance configurations (can override defaults)
  instances = {
    # Basic instance - uses all defaults
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
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
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
  }
}
```

### Advanced Usage with Complex Defaults

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  # Comprehensive default configuration
  defaults = {
    # Instance configuration
    instance_type = "t3.micro"
    ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
    
    # Security and monitoring
    monitoring = true
    disable_api_termination = false
    disable_api_stop = false
    
    # Metadata options
    metadata_options = {
      http_endpoint               = "enabled"
      http_put_response_hop_limit = 1
      http_tokens                 = "required"
    }
    
    # Common tags
    tags = {
      Environment = "dev"
      Project     = "example"
      ManagedBy   = "terraform"
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
    
    # EBS defaults
    enable_volume_tags = true
    volume_tags = {
      ManagedBy = "terraform"
    }
  }

  instances = {
    # Production web server with overrides
    prod_web = {
      name = "prod-web-server"
      instance_type = "t3.small"
      subnet_id = "subnet-12345678"
      
      # Override tags for production
      tags = {
        Environment = "prod"
        Role        = "web-server"
        Project     = "example"
        ManagedBy   = "terraform"
      }
      
      # Production security group
      security_group_ingress_rules = {
        http = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
        https = {
          from_port   = 443
          to_port     = 443
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
        }
      }
      
      # Production settings
      monitoring = true
      disable_api_termination = true
      create_eip = true
    }
    
    # Development instance with minimal overrides
    dev_instance = {
      name = "dev-instance"
      subnet_id = "subnet-12345678"
      # Uses all defaults except name and subnet_id
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 6.0 |

## Inputs

### defaults

Default configuration that applies to all instances. Individual instances can override these values.

```hcl
defaults = {
  instance_type = "t3.micro"
  tags = {
    Environment = "dev"
    Project     = "example"
  }
  # ... all other configuration options
}
```

### instances

A map of EC2 instances to create. Each instance can override values from the defaults variable.

```hcl
instances = {
  instance_key = {
    name = "instance-name"
    subnet_id = "subnet-12345678"
    # ... override any defaults as needed
  }
}
```

### Default Configuration Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create an instance | `bool` | `true` | no |
| region | Region where the resource(s) will be managed | `string` | `null` | no |
| ami | ID of AMI to use for the instance | `string` | `null` | no |
| ami_ssm_parameter | SSM parameter name for the AMI ID | `string` | `"/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"` | no |
| ignore_ami_changes | Whether changes to the AMI ID should be ignored | `bool` | `false` | no |
| associate_public_ip_address | Whether to associate a public IP address | `bool` | `null` | no |
| availability_zone | AZ to start the instance in | `string` | `null` | no |
| capacity_reservation_specification | Capacity reservation specification | `object` | `null` | no |
| cpu_options | CPU options for the instance | `object` | `null` | no |
| cpu_credits | Credit option for CPU usage | `string` | `null` | no |
| disable_api_termination | Enable EC2 Instance Termination Protection | `bool` | `null` | no |
| disable_api_stop | Enable EC2 Instance Stop Protection | `bool` | `null` | no |
| ebs_optimized | Whether the instance will be EBS-optimized | `bool` | `null` | no |
| enclave_options_enabled | Enable Nitro Enclaves | `bool` | `null` | no |
| enable_primary_ipv6 | Enable primary IPv6 address | `bool` | `null` | no |
| ephemeral_block_device | Ephemeral block device configuration | `map(object)` | `null` | no |
| get_password_data | Wait for password data | `bool` | `null` | no |
| hibernation | Enable hibernation support | `bool` | `null` | no |
| host_id | Dedicated host ID | `string` | `null` | no |
| host_resource_group_arn | Host resource group ARN | `string` | `null` | no |
| iam_instance_profile | IAM instance profile name | `string` | `null` | no |
| instance_initiated_shutdown_behavior | Shutdown behavior | `string` | `null` | no |
| instance_market_options | Market options for the instance | `object` | `null` | no |
| instance_type | Type of instance to start | `string` | `"t3.micro"` | no |
| ipv6_address_count | Number of IPv6 addresses | `number` | `null` | no |
| ipv6_addresses | List of IPv6 addresses | `list(string)` | `null` | no |
| key_name | Key pair name | `string` | `null` | no |
| launch_template | Launch template configuration | `object` | `null` | no |
| maintenance_options | Maintenance options | `object` | `null` | no |
| metadata_options | Metadata options | `object` | `{ http_endpoint = "enabled", http_put_response_hop_limit = 1, http_tokens = "required" }` | no |
| monitoring | Enable detailed monitoring | `bool` | `null` | no |
| network_interface | Network interface configuration | `map(object)` | `null` | no |
| placement_group | Placement group name | `string` | `null` | no |
| placement_partition_number | Placement partition number | `number` | `null` | no |
| private_dns_name_options | Private DNS name options | `object` | `null` | no |
| private_ip | Private IP address | `string` | `null` | no |
| root_block_device | Root block device configuration | `object` | `null` | no |
| secondary_private_ips | Secondary private IP addresses | `list(string)` | `null` | no |
| source_dest_check | Source/destination check | `bool` | `null` | no |
| subnet_id | VPC Subnet ID | `string` | `null` | no |
| tags | Tags to assign to the resource | `map(string)` | `{}` | no |
| instance_tags | Additional tags for the instance | `map(string)` | `{}` | no |
| tenancy | Instance tenancy | `string` | `null` | no |
| user_data | User data script | `string` | `null` | no |
| user_data_base64 | Base64 encoded user data | `string` | `null` | no |
| user_data_replace_on_change | Replace on user data change | `bool` | `null` | no |
| volume_tags | Tags for volumes | `map(string)` | `{}` | no |
| enable_volume_tags | Enable volume tags | `bool` | `true` | no |
| vpc_security_group_ids | Security group IDs | `list(string)` | `[]` | no |
| timeouts | Timeout configuration | `map(string)` | `{}` | no |

### Instance Configuration Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create an instance | `bool` | `null` | no |
| name | Name to be used on EC2 instance created | `string` | `""` | yes |
| region | Region where the resource(s) will be managed | `string` | `null` | no |
| ami | ID of AMI to use for the instance | `string` | `null` | no |
| ami_ssm_parameter | SSM parameter name for the AMI ID | `string` | `null` | no |
| ignore_ami_changes | Whether changes to the AMI ID should be ignored | `bool` | `null` | no |
| associate_public_ip_address | Whether to associate a public IP address | `bool` | `null` | no |
| availability_zone | AZ to start the instance in | `string` | `null` | no |
| capacity_reservation_specification | Capacity reservation specification | `object` | `null` | no |
| cpu_options | CPU options for the instance | `object` | `null` | no |
| cpu_credits | Credit option for CPU usage | `string` | `null` | no |
| disable_api_termination | Enable EC2 Instance Termination Protection | `bool` | `null` | no |
| disable_api_stop | Enable EC2 Instance Stop Protection | `bool` | `null` | no |
| ebs_optimized | Whether the instance will be EBS-optimized | `bool` | `null` | no |
| enclave_options_enabled | Enable Nitro Enclaves | `bool` | `null` | no |
| enable_primary_ipv6 | Enable primary IPv6 address | `bool` | `null` | no |
| ephemeral_block_device | Ephemeral block device configuration | `map(object)` | `null` | no |
| get_password_data | Wait for password data | `bool` | `null` | no |
| hibernation | Enable hibernation support | `bool` | `null` | no |
| host_id | Dedicated host ID | `string` | `null` | no |
| host_resource_group_arn | Host resource group ARN | `string` | `null` | no |
| iam_instance_profile | IAM instance profile name | `string` | `null` | no |
| instance_initiated_shutdown_behavior | Shutdown behavior | `string` | `null` | no |
| instance_market_options | Market options for the instance | `object` | `null` | no |
| instance_type | Type of instance to start | `string` | `null` | no |
| ipv6_address_count | Number of IPv6 addresses | `number` | `null` | no |
| ipv6_addresses | List of IPv6 addresses | `list(string)` | `null` | no |
| key_name | Key pair name | `string` | `null` | no |
| launch_template | Launch template configuration | `object` | `null` | no |
| maintenance_options | Maintenance options | `object` | `null` | no |
| metadata_options | Metadata options | `object` | `null` | no |
| monitoring | Enable detailed monitoring | `bool` | `null` | no |
| network_interface | Network interface configuration | `map(object)` | `null` | no |
| placement_group | Placement group name | `string` | `null` | no |
| placement_partition_number | Placement partition number | `number` | `null` | no |
| private_dns_name_options | Private DNS name options | `object` | `null` | no |
| private_ip | Private IP address | `string` | `null` | no |
| root_block_device | Root block device configuration | `object` | `null` | no |
| secondary_private_ips | Secondary private IP addresses | `list(string)` | `null` | no |
| source_dest_check | Source/destination check | `bool` | `null` | no |
| subnet_id | VPC Subnet ID | `string` | `null` | no |
| tags | Tags to assign to the resource | `map(string)` | `null` | no |
| instance_tags | Additional tags for the instance | `map(string)` | `null` | no |
| tenancy | Instance tenancy | `string` | `null` | no |
| user_data | User data script | `string` | `null` | no |
| user_data_base64 | Base64 encoded user data | `string` | `null` | no |
| user_data_replace_on_change | Replace on user data change | `bool` | `null` | no |
| volume_tags | Tags for volumes | `map(string)` | `null` | no |
| enable_volume_tags | Enable volume tags | `bool` | `null` | no |
| vpc_security_group_ids | Security group IDs | `list(string)` | `null` | no |
| timeouts | Timeout configuration | `map(string)` | `null` | no |

### Spot Instance Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_spot_instance | Create spot instance | `bool` | `false` | no |
| spot_instance_interruption_behavior | Spot interruption behavior | `string` | `null` | no |
| spot_launch_group | Spot launch group | `string` | `null` | no |
| spot_price | Maximum spot price | `string` | `null` | no |
| spot_type | Spot instance type | `string` | `null` | no |
| spot_wait_for_fulfillment | Wait for spot fulfillment | `bool` | `null` | no |
| spot_valid_from | Spot valid from date | `string` | `null` | no |
| spot_valid_until | Spot valid until date | `string` | `null` | no |

### EBS Volumes Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ebs_volumes | Additional EBS volumes | `map(object)` | `null` | no |

Each EBS volume can have the following attributes:
- `encrypted` - Whether the volume is encrypted
- `final_snapshot` - Create final snapshot
- `iops` - IOPS for the volume
- `kms_key_id` - KMS key ID for encryption
- `multi_attach_enabled` - Enable multi-attach
- `outpost_arn` - Outpost ARN
- `size` - Volume size in GB
- `snapshot_id` - Snapshot ID to restore from
- `tags` - Tags for the volume
- `throughput` - Volume throughput
- `type` - Volume type
- `device_name` - Device name for attachment
- `force_detach` - Force detach on destroy
- `skip_destroy` - Skip volume destruction
- `stop_instance_before_detaching` - Stop instance before detaching

### IAM Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_iam_instance_profile | Create IAM instance profile | `bool` | `false` | no |
| create_instance_profile_for_existing_role | Create instance profile for existing IAM role | `bool` | `false` | no |
| iam_role_name | IAM role name | `string` | `null` | no |
| iam_role_use_name_prefix | Use name prefix for IAM role | `bool` | `true` | no |
| iam_role_path | IAM role path | `string` | `null` | no |
| iam_role_description | IAM role description | `string` | `null` | no |
| iam_role_permissions_boundary | IAM role permissions boundary | `string` | `null` | no |
| iam_role_policies | IAM role policies | `map(string)` | `{}` | no |
| iam_role_tags | IAM role tags | `map(string)` | `{}` | no |
| instance_profile_name | Instance profile name | `string` | `null` | no |
| instance_profile_use_name_prefix | Use name prefix for instance profile | `bool` | `true` | no |
| instance_profile_path | Instance profile path | `string` | `null` | no |
| instance_profile_tags | Instance profile tags | `map(string)` | `{}` | no |

### Security Group Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_security_group | Create security group | `bool` | `true` | no |
| security_group_name | Security group name | `string` | `null` | no |
| security_group_use_name_prefix | Use name prefix for security group | `bool` | `true` | no |
| security_group_description | Security group description | `string` | `null` | no |
| security_group_vpc_id | VPC ID for security group | `string` | `null` | no |
| security_group_tags | Security group tags | `map(string)` | `{}` | no |
| security_group_egress_rules | Egress rules | `map(object)` | `null` | no |
| security_group_ingress_rules | Ingress rules | `map(object)` | `null` | no |

Each security group rule can have:
- `cidr_ipv4` - IPv4 CIDR block
- `cidr_ipv6` - IPv6 CIDR block
- `description` - Rule description
- `from_port` - Starting port
- `ip_protocol` - IP protocol
- `prefix_list_id` - Prefix list ID
- `referenced_security_group_id` - Referenced security group ID
- `tags` - Rule tags
- `to_port` - Ending port

### Elastic IP Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_eip | Create Elastic IP | `bool` | `false` | no |
| eip_domain | EIP domain | `string` | `"vpc"` | no |
| eip_tags | EIP tags | `map(string)` | `{}` | no |

## Outputs

All outputs are provided as maps, with the instance key as the map key:

| Name | Description |
|------|-------------|
| instances | Map of all created EC2 instances |
| instance_ids | Map of instance IDs |
| instance_arns | Map of instance ARNs |
| instance_states | Map of instance states |
| public_ips | Map of public IP addresses |
| private_ips | Map of private IP addresses |
| public_dns | Map of public DNS names |
| private_dns | Map of private DNS names |
| availability_zones | Map of availability zones |
| iam_role_arns | Map of IAM role ARNs |
| iam_instance_profile_arns | Map of IAM instance profile ARNs |
| ebs_volumes | Map of EBS volumes for all instances |
| spot_bid_statuses | Map of spot bid statuses |
| spot_request_states | Map of spot request states |
| spot_instance_ids | Map of spot instance IDs |
| root_block_devices | Map of root block device information |
| ebs_block_devices | Map of EBS block device information |
| ephemeral_block_devices | Map of ephemeral block device information |
| tags_all | Map of all tags for all instances |
| ipv6_addresses | Map of IPv6 addresses |
| primary_network_interface_ids | Map of primary network interface IDs |
| outpost_arns | Map of outpost ARNs |
| password_data | Map of password data |
| capacity_reservation_specifications | Map of capacity reservation specifications |
| amis | Map of AMI IDs |
| iam_role_names | Map of IAM role names |
| iam_role_unique_ids | Map of IAM role unique IDs |
| iam_instance_profile_ids | Map of IAM instance profile IDs |
| iam_instance_profile_unique_ids | Map of IAM instance profile unique IDs |

## Examples

### Basic Multiple Instances with Defaults

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  # Set common defaults
  defaults = {
    instance_type = "t3.micro"
    tags = {
      Environment = "dev"
      Project     = "example"
    }
  }

  instances = {
    web = {
      name = "web-server"
      subnet_id = "subnet-12345678"
    }
    
    app = {
      name = "app-server"
      subnet_id = "subnet-12345678"
    }
    
    db = {
      name = "db-server"
      subnet_id = "subnet-12345678"
    }
  }
}
```

### EC2 Instances with Security Groups and EIPs

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  # Common defaults
  defaults = {
    instance_type = "t3.small"
    create_security_group = true
    security_group_ingress_rules = {
      ssh = {
        from_port   = 22
        to_port     = 22
        ip_protocol = "tcp"
        cidr_ipv4   = "10.0.0.0/16"
      }
    }
    tags = {
      Environment = "prod"
      Project     = "example"
    }
  }

  instances = {
    web_server = {
      name = "web-server"
      subnet_id = "subnet-12345678"
      
      # Override security group rules for web server
      security_group_ingress_rules = {
        http = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
        https = {
          from_port   = 443
          to_port     = 443
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
        }
      }
      
      create_eip = true
      
      tags = {
        Environment = "prod"
        Role        = "web-server"
        Project     = "example"
      }
    }
  }
}
```

### Spot Instances

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  defaults = {
    instance_type = "t3.micro"
    tags = {
      Environment = "dev"
      Project     = "example"
    }
  }

  instances = {
    spot_worker = {
      name = "spot-worker"
      subnet_id = "subnet-12345678"
      
      # Override to create spot instance
      create_spot_instance = true
      spot_price = "0.01"
      
      tags = {
        Environment = "dev"
        InstanceType = "spot"
        Project     = "example"
      }
    }
  }
}
```

### Instances with IAM Roles and EBS Volumes

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  defaults = {
    instance_type = "t3.medium"
    create_iam_instance_profile = false
    tags = {
      Environment = "prod"
      Project     = "example"
    }
  }

  instances = {
    app_server = {
      name = "app-server"
      subnet_id = "subnet-12345678"
      
      # Override to create IAM profile
      create_iam_instance_profile = true
      iam_role_policies = {
        s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      }
      
      # Add EBS volumes
      ebs_volumes = {
        data = {
          size = 100
          type = "gp3"
          encrypted = true
          tags = {
            Name = "app-data"
          }
        }
        logs = {
          size = 50
          type = "gp3"
          encrypted = true
          tags = {
            Name = "app-logs"
          }
        }
      }
      
      tags = {
        Environment = "prod"
        Role        = "app-server"
        Project     = "example"
      }
    }
  }
}
```

### Using Existing IAM Roles

The wrapper module supports using existing IAM roles. You can specify an existing IAM role name and the module will use it instead of creating a new one.

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  # Default configuration with existing IAM role
  defaults = {
    instance_type = "t3.micro"
    create_iam_instance_profile = false  # Don't create new IAM profile
    iam_instance_profile = "existing-ec2-role"  # Use existing IAM role name
    tags = {
      Environment = "dev"
      Project     = "example"
    }
  }

  instances = {
    # Instance using default existing IAM role
    basic = {
      name = "basic-instance"
      subnet_id = "subnet-12345678"
    }
    
    # Instance using different existing IAM role
    custom_role = {
      name = "custom-role-instance"
      subnet_id = "subnet-12345678"
      
      # Override to use different existing IAM role
      iam_instance_profile = "custom-ec2-role"
    }
    
    # Instance that creates its own IAM role
    new_role = {
      name = "new-role-instance"
      subnet_id = "subnet-12345678"
      
      # Override to create new IAM role
      create_iam_instance_profile = true
      iam_role_name = "new-instance-role"
      iam_role_policies = {
        s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
        cloudwatch_agent = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }
    }
  }
}
```

### Mixed IAM Role Strategy

You can mix and match existing IAM roles and newly created ones:

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  defaults = {
    instance_type = "t3.micro"
    create_iam_instance_profile = false
    iam_instance_profile = "default-ec2-role"  # Default existing role
    tags = {
      Environment = "prod"
      Project     = "example"
    }
  }

  instances = {
    # Uses default existing IAM role
    web_server = {
      name = "web-server"
      subnet_id = "subnet-12345678"
    }
    
    # Uses different existing IAM role
    app_server = {
      name = "app-server"
      subnet_id = "subnet-12345678"
      iam_instance_profile = "app-ec2-role"  # Different existing role
    }
    
    # Creates new IAM role with custom policies
    db_server = {
      name = "db-server"
      subnet_id = "subnet-12345678"
      
      create_iam_instance_profile = true
      iam_role_name = "db-server-role"
      iam_role_policies = {
        rds_full_access = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
        secrets_manager = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
      }
      iam_role_tags = {
        Purpose = "Database server role"
        Environment = "prod"
      }
    }
  }
}
```

## Accessing Outputs

To access outputs for specific instances, use the instance key:

```hcl
# Get the public IP of a specific instance
output "web_server_ip" {
  value = module.ec2_instances.public_ips["web_server"]
}

# Get all instance IDs
output "all_instance_ids" {
  value = module.ec2_instances.instance_ids
}
```

## License

This module is based on the terraform-aws-ec2-instance module and follows the same license terms.

## Contributing

This is a wrapper module. For issues or contributions related to the core functionality, please refer to the original [terraform-aws-ec2-instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance) repository.
