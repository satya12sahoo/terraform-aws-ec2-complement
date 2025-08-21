# EC2 Instance Module

module "ec2_instance" {
  for_each = local.enabled_instances
  source   = "../terraform-aws-ec2-instance"

  # Core variables
  create = each.value.create
  name   = each.value.name
  region = each.value.region

  # Instance configuration
  ami                         = each.value.ami
  ami_ssm_parameter          = each.value.ami_ssm_parameter
  ignore_ami_changes         = each.value.ignore_ami_changes
  associate_public_ip_address = each.value.associate_public_ip_address
  availability_zone          = each.value.availability_zone
  capacity_reservation_specification = each.value.capacity_reservation_specification
  cpu_options                = each.value.cpu_options
  cpu_credits                = each.value.cpu_credits
  disable_api_termination    = each.value.disable_api_termination
  disable_api_stop           = each.value.disable_api_stop
  ebs_optimized              = each.value.ebs_optimized
  enclave_options_enabled    = each.value.enclave_options_enabled
  enable_primary_ipv6        = each.value.enable_primary_ipv6
  ephemeral_block_device     = each.value.ephemeral_block_device
  get_password_data          = each.value.get_password_data
  hibernation                = each.value.hibernation
  host_id                    = each.value.host_id
  host_resource_group_arn    = each.value.host_resource_group_arn
  iam_instance_profile       = each.value.create_instance_profile_for_existing_role ? aws_iam_instance_profile.existing_role_profile[each.key].name : each.value.iam_instance_profile
  instance_initiated_shutdown_behavior = each.value.instance_initiated_shutdown_behavior
  instance_market_options    = each.value.instance_market_options
  instance_type              = each.value.instance_type
  ipv6_address_count         = each.value.ipv6_address_count
  ipv6_addresses             = each.value.ipv6_addresses
  key_name                   = each.value.key_name
  launch_template            = each.value.launch_template
  maintenance_options        = each.value.maintenance_options
  metadata_options           = each.value.metadata_options
  monitoring                 = each.value.monitoring
  network_interface          = each.value.network_interface
  placement_group            = each.value.placement_group
  placement_partition_number = each.value.placement_partition_number
  private_dns_name_options   = each.value.private_dns_name_options
  private_ip                 = each.value.private_ip
  root_block_device          = each.value.root_block_device
  secondary_private_ips      = each.value.secondary_private_ips
  source_dest_check          = each.value.source_dest_check
  subnet_id                  = each.value.subnet_id
  tags                       = each.value.tags
  instance_tags              = each.value.instance_tags
  tenancy                    = each.value.tenancy
  user_data                  = each.value.user_data
  user_data_base64           = each.value.user_data_base64
  user_data_replace_on_change = each.value.user_data_replace_on_change
  volume_tags                = each.value.volume_tags
  enable_volume_tags         = each.value.enable_volume_tags
  vpc_security_group_ids     = each.value.vpc_security_group_ids
  timeouts                   = each.value.timeouts

  # Spot instance configuration
  create_spot_instance              = each.value.create_spot_instance
  spot_instance_interruption_behavior = each.value.spot_instance_interruption_behavior
  spot_launch_group                 = each.value.spot_launch_group
  spot_price                        = each.value.spot_price
  spot_type                         = each.value.spot_type
  spot_wait_for_fulfillment         = each.value.spot_wait_for_fulfillment
  spot_valid_from                   = each.value.spot_valid_from
  spot_valid_until                  = each.value.spot_valid_until

  # EBS volumes
  ebs_volumes = each.value.ebs_volumes

  # IAM configuration
  create_iam_instance_profile    = each.value.create_iam_instance_profile
  iam_role_name                  = each.value.iam_role_name
  iam_role_use_name_prefix       = each.value.iam_role_use_name_prefix
  iam_role_path                  = each.value.iam_role_path
  iam_role_description           = each.value.iam_role_description
  iam_role_permissions_boundary  = each.value.iam_role_permissions_boundary
  iam_role_policies              = each.value.iam_role_policies
  iam_role_tags                  = each.value.iam_role_tags

  # Security group configuration
  create_security_group          = each.value.create_security_group
  security_group_name            = each.value.security_group_name
  security_group_use_name_prefix = each.value.security_group_use_name_prefix
  security_group_description     = each.value.security_group_description
  security_group_vpc_id          = each.value.security_group_vpc_id
  security_group_tags            = each.value.security_group_tags
  security_group_egress_rules    = each.value.security_group_egress_rules
  security_group_ingress_rules   = each.value.security_group_ingress_rules

  # Elastic IP configuration
  create_eip = each.value.create_eip
  eip_domain = each.value.eip_domain
  eip_tags   = each.value.eip_tags
}
