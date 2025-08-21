# Outputs from the example instances

output "all_instances" {
  description = "All created instances"
  value       = module.ec2_instances.instances
}

output "instance_ids" {
  description = "IDs of all created instances"
  value       = module.ec2_instances.instance_ids
}

output "public_ips" {
  description = "Public IPs of all instances"
  value       = module.ec2_instances.public_ips
}

output "private_ips" {
  description = "Private IPs of all instances"
  value       = module.ec2_instances.private_ips
}

output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = module.ec2_instances.public_ips["web_server"]
}

output "web_server_public_dns" {
  description = "Public DNS of the web server"
  value       = module.ec2_instances.public_dns["web_server"]
}

output "spot_instance_id" {
  description = "ID of the spot instance"
  value       = module.ec2_instances.instance_ids["spot_instance"]
}

output "spot_instance_bid_status" {
  description = "Spot bid status of the spot instance"
  value       = module.ec2_instances.spot_bid_statuses["spot_instance"]
}

output "app_server_iam_role_arn" {
  description = "IAM role ARN of the app server"
  value       = module.ec2_instances.iam_role_arns["app_server"]
}

output "app_server_ebs_volumes" {
  description = "EBS volumes attached to the app server"
  value       = module.ec2_instances.ebs_volumes["app_server"]
}

output "db_server_private_ip" {
  description = "Private IP of the database server"
  value       = module.ec2_instances.private_ips["db_server"]
}

output "availability_zones" {
  description = "Availability zones of all instances"
  value       = module.ec2_instances.availability_zones
}
