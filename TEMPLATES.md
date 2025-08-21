# Dynamic Templates System

## 🎯 Overview

The Terraform AWS EC2 Instance Wrapper now supports a **Dynamic Templates System** that allows you to create reusable configurations based on user input, rather than being limited to hardcoded templates.

## 🚀 Key Features

### ✅ **Dynamic Template Creation**
- Create templates based on user input parameters
- Variable substitution in user data and tags
- Pattern inheritance from predefined templates
- Fully configurable template parameters

### ✅ **Predefined Patterns**
- `web_server`: Production web server with load balancer
- `database_server`: Database server with backups
- `application_server`: Application server with scheduling
- `development_server`: Development server with cost optimization
- `bastion_host`: Secure bastion host
- `high_performance`: High-performance server

### ✅ **Template Inheritance**
- Inherit from predefined patterns
- Override specific parameters
- Add new features to existing patterns

### ✅ **Variable Substitution**
- Use `{instance_name}` in user data templates
- Dynamic tag generation
- Instance-specific customization

## 📋 Usage Examples

### 1. **Using Predefined Templates**

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"
  
  defaults = {
    subnet_id = "subnet-12345678"
  }
  
  instances = {
    web1 = {
      name = "web-server-1"
      template = "web_server"  # Use predefined template
      subnet_id = "subnet-87654321"
    }
    
    db1 = {
      name = "database-1"
      template = "database_server"  # Use predefined template
      subnet_id = "subnet-87654322"
    }
  }
}
```

### 2. **Creating Custom Templates**

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"
  
  # Define custom templates
  templates = {
    custom_web = {
      description = "Custom web server template"
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
      }
    }
  }
  
  instances = {
    web1 = {
      name = "custom-web-1"
      template = "custom_web"
      subnet_id = "subnet-87654321"
    }
  }
}
```

### 3. **Template Inheritance**

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"
  
  templates = {
    enhanced_web = {
      description = "Enhanced web server based on web_server pattern"
      pattern = "web_server"  # Inherit from predefined pattern
      instance_type = "t3.xlarge"  # Override instance type
      enable_advanced_features = true  # Add new features
      
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
  }
  
  instances = {
    web1 = {
      name = "enhanced-web-1"
      template = "enhanced_web"
      subnet_id = "subnet-87654321"
    }
  }
}
```

### 4. **Environment-Specific Templates**

```hcl
module "ec2_instances" {
  source = "./terraform-aws-ec2-instance-wrapper"
  
  templates = {
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
  
  instances = {
    prod_web1 = {
      name = "prod-web-1"
      template = "prod_web"
      subnet_id = "subnet-87654321"
    }
    
    dev_web1 = {
      name = "dev-web-1"
      template = "dev_web"
      subnet_id = "subnet-87654322"
    }
  }
}
```

## 🔧 Template Configuration Options

### **Basic Configuration**
```hcl
templates = {
  my_template = {
    description = "Template description"
    instance_type = "t3.medium"
    ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  }
}
```

### **Security Configuration**
```hcl
templates = {
  my_template = {
    enable_enhanced_security = true
    enable_imdsv2 = true
    enable_encryption_by_default = true
    enable_security_hardening = false
  }
}
```

### **Monitoring Configuration**
```hcl
templates = {
  my_template = {
    enable_cloudwatch_agent = true
    detailed_monitoring = false
  }
}
```

### **Cost Optimization**
```hcl
templates = {
  my_template = {
    enable_scheduling = false
    enable_cost_optimization = false
  }
}
```

### **Backup Configuration**
```hcl
templates = {
  my_template = {
    enable_automated_backups = false
  }
}
```

### **Network Configuration**
```hcl
templates = {
  my_template = {
    enable_vpc_endpoints = false
    enable_load_balancer = false
    enable_auto_scaling_group = false
  }
}
```

### **Compliance Configuration**
```hcl
templates = {
  my_template = {
    enable_compliance = false
  }
}
```

### **Advanced Features**
```hcl
templates = {
  my_template = {
    enable_advanced_features = false
  }
}
```

### **User Data Template**
```hcl
templates = {
  my_template = {
    user_data_template = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
      echo "Server: {instance_name}" > /var/www/html/index.html
    EOF
  }
}
```

### **Tags Template**
```hcl
templates = {
  my_template = {
    tags_template = {
      Service = "web"
      Environment = "production"
      Team = "web-team"
      Instance = "{instance_name}"
    }
  }
}
```

### **Security Groups Template**
```hcl
templates = {
  my_template = {
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
}
```

### **EBS Volumes Template**
```hcl
templates = {
  my_template = {
    ebs_volumes = {
      data = {
        size = 100
        type = "gp3"
        encrypted = true
        device_name = "/dev/sdf"
      }
      cache = {
        size = 50
        type = "io2"
        encrypted = true
        device_name = "/dev/sdg"
      }
    }
  }
}
```

## 📊 Available Predefined Templates

### **web_server**
- **Instance Type**: `t3.medium`
- **Features**: CloudWatch agent, load balancer, auto scaling, VPC endpoints, compliance
- **Security Groups**: HTTP (80), HTTPS (443)
- **User Data**: Installs and configures Apache HTTP Server
- **Tags**: Service=web, Environment=production, Backup=daily

### **database_server**
- **Instance Type**: `t3.large`
- **Features**: CloudWatch agent, detailed monitoring, automated backups, VPC endpoints, compliance
- **Security Groups**: MySQL (3306)
- **EBS Volumes**: Data volume (100GB)
- **User Data**: Installs and configures MySQL Server
- **Tags**: Service=database, Environment=production, Backup=daily, Encryption=required

### **application_server**
- **Instance Type**: `t3.medium`
- **Features**: CloudWatch agent, scheduling, cost optimization, VPC endpoints
- **Security Groups**: Application (8080)
- **User Data**: Installs Java and Tomcat
- **Tags**: Service=application, Environment=production, Backup=weekly

### **development_server**
- **Instance Type**: `t3.small`
- **Features**: CloudWatch agent, scheduling, cost optimization
- **Security Groups**: SSH (22)
- **User Data**: Installs Git and Docker
- **Tags**: Service=development, Environment=development, Backup=none

### **bastion_host**
- **Instance Type**: `t3.micro`
- **Features**: Security hardening, CloudWatch agent, VPC endpoints, compliance
- **Security Groups**: SSH (22)
- **User Data**: Installs and configures fail2ban
- **Tags**: Service=bastion, Environment=production, Backup=none, Security=high

### **high_performance**
- **Instance Type**: `c5.large`
- **Features**: CloudWatch agent, detailed monitoring, load balancer, auto scaling, VPC endpoints, advanced features
- **Security Groups**: HTTP (80), HTTPS (443)
- **User Data**: Installs and configures Nginx with health check
- **Tags**: Service=high-performance, Environment=production, Backup=daily, Performance=optimized

## 🔄 Variable Substitution

### **Available Variables**
- `{instance_name}`: The name of the instance

### **Usage Examples**
```hcl
templates = {
  my_template = {
    user_data_template = <<-EOF
      #!/bin/bash
      echo "Hello from {instance_name}" > /tmp/greeting.txt
    EOF
    
    tags_template = {
      Name = "{instance_name}"
      Instance = "{instance_name}"
      Description = "Instance {instance_name}"
    }
  }
}
```

## 📈 Template Outputs

The module provides several outputs for template management:

```hcl
# List of available template names
output "available_templates" {
  value = module.ec2_instances.available_templates
}

# Template configurations
output "template_configurations" {
  value = module.ec2_instances.template_configurations
}

# Instances using templates
output "instances_with_templates" {
  value = module.ec2_instances.instances_with_templates
}

# Template usage summary
output "template_usage_summary" {
  value = module.ec2_instances.template_usage_summary
}
```

## 🎯 Best Practices

### **1. Template Organization**
- Use descriptive template names
- Group related templates together
- Document template purposes and requirements

### **2. Variable Substitution**
- Use `{instance_name}` for dynamic content
- Keep templates generic and reusable
- Avoid hardcoding instance-specific values

### **3. Pattern Inheritance**
- Inherit from predefined patterns when possible
- Override only necessary parameters
- Add new features incrementally

### **4. Security**
- Define security groups in templates
- Use least-privilege access
- Enable security features by default

### **5. Cost Optimization**
- Use appropriate instance types
- Enable scheduling for non-production instances
- Configure cost optimization features

### **6. Monitoring**
- Enable CloudWatch agent in templates
- Configure appropriate log groups
- Set up detailed monitoring for production

## 🔍 Troubleshooting

### **Common Issues**

1. **Template Not Found**
   - Check template name spelling
   - Verify template is defined in `templates` variable
   - Ensure template name matches exactly

2. **Variable Substitution Not Working**
   - Verify instance has a `name` attribute
   - Check variable syntax: `{instance_name}`
   - Ensure template is properly applied

3. **Template Inheritance Issues**
   - Check pattern name spelling
   - Verify pattern exists in predefined templates
   - Ensure inheritance syntax is correct

### **Debugging Tips**

1. **Check Template Outputs**
   ```hcl
   terraform output available_templates
   terraform output template_configurations
   terraform output instances_with_templates
   ```

2. **Validate Template Configuration**
   ```hcl
   terraform validate
   terraform plan
   ```

3. **Check Template Application**
   ```hcl
   terraform output template_usage_summary
   ```

## 🚀 Migration from Hardcoded Templates

If you were using the previous hardcoded template system:

1. **No Changes Required**: Predefined templates still work
2. **Enhanced Flexibility**: Now you can create custom templates
3. **Backward Compatible**: All existing configurations continue to work
4. **Gradual Migration**: Migrate to custom templates as needed

The dynamic template system provides much more flexibility while maintaining backward compatibility with the predefined templates.
