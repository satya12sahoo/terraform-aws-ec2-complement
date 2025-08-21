# Terraform EC2 Instance Wrapper - Scenario Configurations

This directory contains pre-configured `.tfvars` files for different deployment scenarios. Each scenario is designed to meet specific requirements and use cases.

## 📁 Available Scenarios

### 1. **minimal.tfvars** - Basic Setup
**Use Case**: Development, testing, or simple applications
**Features**:
- ✅ Basic security groups with common rules
- ✅ Simple CloudWatch monitoring
- ✅ Minimal resource usage
- ✅ Quick deployment

**Usage**:
```bash
terraform plan -var-file="scenarios/minimal.tfvars"
terraform apply -var-file="scenarios/minimal.tfvars"
```

### 2. **production.tfvars** - High Availability
**Use Case**: Production applications requiring high availability
**Features**:
- ✅ Load balancers with health checks
- ✅ Auto scaling groups with policies
- ✅ Comprehensive monitoring with encryption
- ✅ Cost optimization with scheduling
- ✅ VPC endpoints for private connectivity
- ✅ Enhanced security features

**Usage**:
```bash
terraform plan -var-file="scenarios/production.tfvars"
terraform apply -var-file="scenarios/production.tfvars"
```

### 3. **cost-optimized.tfvars** - Cost Optimization
**Use Case**: Development environments, testing, or cost-sensitive applications
**Features**:
- ✅ Spot instances for cost savings
- ✅ Mixed instances policies
- ✅ Aggressive auto scaling
- ✅ Scheduled start/stop
- ✅ Minimal monitoring retention
- ✅ Internal load balancers

**Usage**:
```bash
terraform plan -var-file="scenarios/cost-optimized.tfvars"
terraform apply -var-file="scenarios/cost-optimized.tfvars"
```

### 4. **security-focused.tfvars** - Enhanced Security
**Use Case**: Applications requiring maximum security and compliance
**Features**:
- ✅ Enhanced security groups with restricted access
- ✅ VPC endpoints with custom policies
- ✅ KMS encryption for logs
- ✅ IAM roles with permissions boundaries
- ✅ Comprehensive compliance tagging
- ✅ Maximum log retention for audit

**Usage**:
```bash
terraform plan -var-file="scenarios/security-focused.tfvars"
terraform apply -var-file="scenarios/security-focused.tfvars"
```

### 5. **existing-resources.tfvars** - Use Existing Resources
**Use Case**: When you already have infrastructure in place and want to leverage existing resources
**Features**:
- ✅ Use existing security groups instead of creating new ones
- ✅ Use existing IAM roles and instance profiles
- ✅ Use existing load balancers and target groups
- ✅ Use existing auto scaling groups
- ✅ Use existing CloudWatch log groups
- ✅ Use existing VPC endpoints
- ✅ Minimal resource creation

**Usage**:
```bash
terraform plan -var-file="scenarios/existing-resources.tfvars"
terraform apply -var-file="scenarios/existing-resources.tfvars"
```

### 6. **minimal-child-modules.tfvars** - Minimal Child Module Usage
**Use Case**: When you want to use the wrapper with minimal child module usage
**Features**:
- ✅ Only essential features enabled
- ✅ Most child modules disabled
- ✅ Basic security groups only
- ✅ No IAM, CloudWatch, VPC endpoints, load balancers, or auto scaling
- ✅ Minimal resource creation
- ✅ Fast deployment

**Usage**:
```bash
terraform plan -var-file="scenarios/minimal-child-modules.tfvars"
terraform apply -var-file="scenarios/minimal-child-modules.tfvars"
```

### 7. **aws-console-style.tfvars** - AWS Console-Style Configuration
**Use Case**: When you want AWS Console-like configuration with single row per resource type
**Features**:
- ✅ Each resource type configured in single row/block
- ✅ Clear visual separation between resource types
- ✅ AWS Console-like organization
- ✅ Easy to understand and configure
- ✅ Default to using existing resources
- ✅ Explicit creation flags

**Usage**:
```bash
terraform plan -var-file="scenarios/aws-console-style.tfvars"
terraform apply -var-file="scenarios/aws-console-style.tfvars"
```

## 🔧 Customizing Scenarios

### Modifying Existing Scenarios

1. **Copy a scenario file**:
   ```bash
   cp scenarios/production.tfvars scenarios/my-custom.tfvars
   ```

2. **Edit the file** to match your requirements:
   - Update subnet IDs
   - Modify instance types
   - Adjust security group rules
   - Change monitoring settings

3. **Apply your custom configuration**:
   ```bash
   terraform plan -var-file="scenarios/my-custom.tfvars"
   terraform apply -var-file="scenarios/my-custom.tfvars"
   ```

### Creating New Scenarios

1. **Start with a base scenario**:
   ```bash
   cp scenarios/minimal.tfvars scenarios/my-new-scenario.tfvars
   ```

2. **Add your specific requirements**:
   - Define your instance configurations
   - Set up security groups
   - Configure monitoring
   - Add compliance requirements

3. **Test your configuration**:
   ```bash
   terraform plan -var-file="scenarios/my-new-scenario.tfvars"
   ```

## 📋 Scenario Comparison

| Feature | Minimal | Production | Cost-Optimized | Security-Focused | Existing Resources | Minimal Modules | **AWS Console** |
|---------|---------|------------|----------------|------------------|-------------------|------------------|------------------|
| **Instance Types** | t3.micro | t3.medium | t3.micro (spot) | t3.medium | t3.medium | t3.micro | t3.micro |
| **Load Balancer** | ❌ | ✅ External | ✅ Internal | ✅ Internal | ❌ (Use Existing) | ❌ | ❌ (Use Existing) |
| **Auto Scaling** | ❌ | ✅ Conservative | ✅ Aggressive | ✅ Conservative | ❌ (Use Existing) | ❌ | ❌ (Use Existing) |
| **Spot Instances** | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Scheduling** | ❌ | ✅ Business hours | ✅ Business hours | ❌ | ❌ | ❌ | ✅ (Selective) |
| **VPC Endpoints** | ❌ | ✅ Basic | ❌ | ✅ Comprehensive | ❌ (Use Existing) | ❌ | ❌ (Use Existing) |
| **Log Encryption** | ❌ | ✅ KMS | ❌ | ✅ KMS | ❌ | ❌ | ❌ |
| **Log Retention** | 7 days | 90 days | 7 days | 365+ days | 30 days | ❌ | 30 days |
| **Security Groups** | Basic | Enhanced | Basic | Maximum | ❌ (Use Existing) | Basic | Basic |
| **Compliance Tags** | Basic | SOX | Basic | PCI-DSS | Basic | Basic | Basic |
| **Child Modules** | Basic | All | Most | All | Minimal | Minimal | **Selective** |
| **Configuration Style** | Standard | Standard | Standard | Standard | Standard | Standard | **Single Row** |

## 🚀 Quick Start Guide

### 1. Choose Your Scenario
Based on your requirements, select the appropriate scenario file.

### 2. Update Configuration
Edit the selected `.tfvars` file to match your environment:
- Replace subnet IDs with your actual subnet IDs
- Update AMI IDs for your region
- Modify instance types as needed
- Adjust security group rules for your application

### 3. Deploy
```bash
# Initialize Terraform (first time only)
terraform init

# Plan the deployment
terraform plan -var-file="scenarios/your-scenario.tfvars"

# Apply the configuration
terraform apply -var-file="scenarios/your-scenario.tfvars"
```

### 4. Verify Deployment
```bash
# Check the outputs
terraform output

# List created resources
terraform show
```

## 🔒 Security Considerations

### Before Deployment
- ✅ Review and update subnet IDs
- ✅ Verify AMI IDs for your region
- ✅ Update security group rules for your application
- ✅ Review IAM role names and permissions
- ✅ Check KMS key ARNs if using encryption

### After Deployment
- ✅ Verify security group rules
- ✅ Test connectivity to your instances
- ✅ Check CloudWatch logs
- ✅ Verify auto scaling policies
- ✅ Test load balancer health checks

## 💰 Cost Optimization Tips

### For Development/Testing
- Use `cost-optimized.tfvars` as a base
- Enable spot instances
- Use smaller instance types
- Implement scheduling for non-business hours
- Use internal load balancers

### For Production
- Use `production.tfvars` as a base
- Monitor auto scaling metrics
- Adjust scaling thresholds based on usage
- Review and optimize instance types
- Consider reserved instances for predictable workloads

## 🛠️ Troubleshooting

### Common Issues

1. **Subnet ID Errors**
   - Verify subnet IDs exist in your VPC
   - Check subnet availability zones

2. **AMI ID Errors**
   - Update AMI IDs for your region
   - Verify AMI is available in your account

3. **Security Group Rule Conflicts**
   - Review existing security group rules
   - Ensure no conflicting port ranges

4. **IAM Role Issues**
   - Verify IAM role names exist
   - Check IAM permissions

### Getting Help

- Check Terraform logs: `terraform logs`
- Review CloudWatch logs for application issues
- Verify AWS console for resource creation status
- Use `terraform refresh` to sync state with AWS

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [AWS Auto Scaling Documentation](https://docs.aws.amazon.com/autoscaling/)
- [AWS Load Balancer Documentation](https://docs.aws.amazon.com/elasticloadbalancing/)
