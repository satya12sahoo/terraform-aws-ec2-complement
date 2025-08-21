# EC2 Instance Wrapper Module Examples

This directory contains examples demonstrating how to use the terraform-aws-ec2-instance-wrapper module.

## Examples Overview

### 1. `main.tf` - Comprehensive Example
A complete example showing:
- Default configurations that apply to all instances
- Individual instance overrides
- Multiple instance types (basic, web server, app server, database, spot instance)
- Different IAM role strategies (existing roles, new roles, no roles)
- Security groups, EBS volumes, and EIPs

### 2. `existing-iam-role.tf` - Using Existing IAM Roles
Focused example showing how to:
- Use existing IAM roles instead of creating new ones
- Override default IAM roles for specific instances
- Mix existing roles with no roles
- Best practices for existing infrastructure

### 3. `outputs.tf` - Output Examples
Shows how to access outputs from the module:
- Individual instance outputs
- Map-based outputs for multiple instances
- Common output patterns

## Quick Start

To use any of these examples:

1. **Copy the example file** you want to use to your Terraform configuration
2. **Update the subnet IDs** to match your VPC subnets
3. **Update IAM role names** to match your existing IAM roles (if using existing roles)
4. **Customize the configuration** according to your needs

## Example Usage

### Using Existing IAM Roles

```hcl
# Copy from existing-iam-role.tf
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  defaults = {
    create_iam_instance_profile = false
    iam_instance_profile = "your-existing-ec2-role"  # Your existing role name
  }

  instances = {
    web_server = {
      name = "web-server"
      subnet_id = "subnet-your-subnet-id"
    }
  }
}
```

### Creating New IAM Roles

```hcl
# Copy from main.tf
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"

  defaults = {
    create_iam_instance_profile = true
    iam_role_policies = {
      s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
  }

  instances = {
    app_server = {
      name = "app-server"
      subnet_id = "subnet-your-subnet-id"
    }
  }
}
```

## Important Notes

- **Subnet IDs**: Always replace `subnet-12345678` with your actual subnet IDs
- **IAM Role Names**: Replace example role names with your actual IAM role names
- **Security Groups**: Adjust CIDR blocks and ports according to your network requirements
- **Tags**: Customize tags to match your organization's tagging strategy
- **Instance Types**: Choose appropriate instance types for your workload

## Best Practices

1. **Use defaults for common configurations** to reduce repetition
2. **Override only what's necessary** for individual instances
3. **Use existing IAM roles** when possible to maintain consistency
4. **Apply proper tagging** for resource management
5. **Use appropriate security group rules** for your use case
6. **Consider costs** when choosing instance types and EBS volumes
