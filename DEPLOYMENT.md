# Deployment Guide - Terraform AWS EC2 Complement (Wrapper Module)

This guide explains how to deploy the wrapper module with different scenarios and configurations.

## 📋 Prerequisites

1. **Terraform** (>= 1.0)
2. **AWS CLI** configured with appropriate credentials
3. **Git** for cloning the repository
4. **AWS Account** with appropriate permissions
5. **VPC and Subnet** already created in your AWS account

## 🚀 Quick Deployment

### 1. Clone the Repository

```bash
git clone https://github.com/satya12sahoo/terraform-aws-ec2-complement.git
cd terraform-aws-ec2-complement
```

### 2. Choose a Scenario

The repository includes multiple pre-configured scenarios:

```bash
# List available scenarios
ls scenarios/

# Available scenarios:
# - minimal.tfvars
# - production.tfvars
# - cost-optimized.tfvars
# - security-focused.tfvars
# - existing-resources.tfvars
# - minimal-child-modules.tfvars
# - aws-console-style.tfvars
```

### 3. Deploy with a Scenario

```bash
# Deploy minimal configuration
terraform init
terraform plan -var-file="scenarios/minimal.tfvars"
terraform apply -var-file="scenarios/minimal.tfvars"

# Deploy production configuration
terraform plan -var-file="scenarios/production.tfvars"
terraform apply -var-file="scenarios/production.tfvars"
```

## 📊 Scenario-Specific Deployment

### Minimal Configuration

```bash
# Deploy basic EC2 instance
terraform apply -var-file="scenarios/minimal.tfvars"

# This creates:
# - Basic EC2 instance
# - Minimal security group
# - No additional features
```

### Production Configuration

```bash
# Deploy production-ready setup
terraform apply -var-file="scenarios/production.tfvars"

# This creates:
# - Multiple EC2 instances across AZs
# - Application Load Balancer
# - Auto Scaling Group
# - CloudWatch monitoring
# - Enhanced security
```

### Cost Optimized Configuration

```bash
# Deploy cost-optimized setup
terraform apply -var-file="scenarios/cost-optimized.tfvars"

# This creates:
# - Spot instances
# - Scheduling for cost savings
# - Auto scaling policies
# - Resource optimization
```

### Existing Resources Configuration

```bash
# Deploy using existing AWS resources
terraform apply -var-file="scenarios/existing-resources.tfvars"

# This uses:
# - Existing security groups
# - Existing IAM roles
# - Existing load balancers
# - Minimal new resource creation
```

## 🔧 Custom Configuration

### Create Your Own Configuration

1. **Copy a scenario file as a starting point:**

```bash
cp scenarios/minimal.tfvars my-config.tfvars
```

2. **Edit the configuration:**

```hcl
# my-config.tfvars
name_prefix = "my-app-"
common_tags = {
  Environment = "development"
  Project     = "my-project"
  Owner       = "my-team"
}

defaults = {
  instance_type = "t3.medium"
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  subnet_id     = "subnet-12345678"        # Your subnet ID
  
  # Enable features you need
  create_security_group = true
  create_cloudwatch_agent = true
  create_load_balancer = false
  create_auto_scaling_group = false
}

instances = {
  web-server = {
    name = "web-server"
    # Instance-specific overrides
    instance_type = "t3.large"
  }
  
  app-server = {
    name = "app-server"
    # Different configuration
    create_cloudwatch_agent = false
  }
}
```

3. **Deploy your configuration:**

```bash
terraform plan -var-file="my-config.tfvars"
terraform apply -var-file="my-config.tfvars"
```

### Advanced Custom Configuration

```hcl
# advanced-config.tfvars
name_prefix = "advanced-"
common_tags = {
  Environment = "production"
  Project     = "advanced-app"
  CostCenter  = "IT-001"
}

defaults = {
  instance_type = "t3.medium"
  ami           = "ami-0c02fb55956c7d316"
  subnet_id     = "subnet-12345678"
  
  # Enable all advanced features
  create_security_group = true
  create_instance_profile_for_existing_role = true
  create_cloudwatch_agent = true
  create_scheduling = true
  create_vpc_endpoints = true
  create_load_balancer = true
  create_auto_scaling_group = true
  
  # Security enhancements
  enable_imdsv2 = true
  detailed_monitoring = true
  
  # CloudWatch configuration
  cloudwatch_agent_config = {
    create_log_group = true
    log_group_name = "/aws/ec2/advanced"
    log_retention_days = 90
  }
  
  # Load balancer configuration
  load_balancer_config = {
    create_load_balancer = true
    load_balancer_type = "application"
    enable_deletion_protection = true
  }
  
  # Auto scaling configuration
  auto_scaling_config = {
    create_auto_scaling_group = true
    min_size = 2
    max_size = 10
    desired_capacity = 2
  }
}

instances = {
  web-1 = {
    name = "web-1"
    availability_zone = "us-east-1a"
    instance_type = "t3.large"
  }
  
  web-2 = {
    name = "web-2"
    availability_zone = "us-east-1b"
    instance_type = "t3.large"
  }
  
  app-1 = {
    name = "app-1"
    availability_zone = "us-east-1a"
    instance_type = "t3.xlarge"
    
    # Instance-specific overrides
    create_cloudwatch_agent = false
    create_load_balancer = false
  }
}
```

## 🔍 Monitoring and Management

### Check Deployment Status

```bash
# List all resources
terraform state list

# Show specific resource details
terraform show

# Get outputs
terraform output
```

### Monitor Resources

```bash
# Get instance IDs
terraform output instance_ids

# Get load balancer ARN
terraform output load_balancer_arns

# Get security group IDs
terraform output security_group_ids
```

### Update Configuration

```bash
# Modify your tfvars file
# Then plan and apply changes
terraform plan -var-file="my-config.tfvars"
terraform apply -var-file="my-config.tfvars"
```

## 🧹 Cleanup and Destruction

### Destroy All Resources

```bash
# Destroy with the same configuration used for creation
terraform destroy -var-file="scenarios/minimal.tfvars"
```

### Destroy Specific Resources

```bash
# Destroy specific instances
terraform destroy -target=module.ec2_instances["web-server"]

# Destroy specific modules
terraform destroy -target=module.load_balancer
terraform destroy -target=module.autoscaling
```

### Partial Cleanup

```bash
# Remove specific instances from configuration
# Then apply to destroy only those instances
terraform apply -var-file="my-config.tfvars"
```

## 🔍 Troubleshooting

### Common Issues

1. **VPC/Subnet Not Found**
   ```bash
   # Verify your VPC and subnet IDs
   aws ec2 describe-vpcs
   aws ec2 describe-subnets
   ```

2. **Permission Errors**
   ```bash
   # Check AWS credentials
   aws sts get-caller-identity
   
   # Verify IAM permissions
   aws iam get-user
   ```

3. **Module Source Errors**
   ```bash
   # Ensure child modules are available
   # Update source paths in main.tf if needed
   ```

### Debug Commands

```bash
# Validate configuration
terraform validate

# Check what will be created
terraform plan -detailed-exitcode -var-file="scenarios/minimal.tfvars"

# Show current state
terraform show

# Refresh state
terraform refresh
```

### Log Analysis

```bash
# Enable Terraform logging
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Run terraform commands
terraform apply -var-file="scenarios/minimal.tfvars"

# Check logs
tail -f terraform.log
```

## 📚 Best Practices

### 1. **Environment Management**
   - Use different tfvars files for different environments
   - Use Terraform workspaces for environment separation
   - Use remote state storage for team collaboration

### 2. **Security**
   - Review security group rules before deployment
   - Use least privilege IAM policies
   - Enable CloudTrail for audit logging

### 3. **Cost Management**
   - Start with minimal configuration
   - Monitor costs after deployment
   - Use appropriate instance types
   - Enable auto scaling for cost optimization

### 4. **State Management**
   ```bash
   # Configure remote state
   terraform init \
     -backend-config="bucket=my-terraform-state" \
     -backend-config="key=ec2-complement/terraform.tfstate" \
     -backend-config="region=us-east-1"
   ```

## 🔗 Related Documentation

- [Main README](README.md)
- [Scenarios Documentation](scenarios/README.md)
- [Naming Convention Improvements](NAMING_CONVENTION_IMPROVEMENTS.md)
- [Modular Architecture](MODULAR_ARCHITECTURE.md)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## 🆘 Support

If you encounter issues:

1. Check the [troubleshooting section](#troubleshooting)
2. Review the scenario documentation
3. Check the [Base Repository](https://github.com/satya12sahoo/terraform-aws-ec2-base) for child module details
4. Create an issue in the repository
5. Review Terraform and AWS provider documentation
