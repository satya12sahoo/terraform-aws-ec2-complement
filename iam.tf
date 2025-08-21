# IAM Resources

# Create instance profiles for existing IAM roles when needed
resource "aws_iam_instance_profile" "existing_role_profile" {
  for_each = {
    for k, v in local.enabled_instances : k => v
    if v.create_instance_profile_for_existing_role && v.iam_instance_profile != null
  }

  name        = each.value.instance_profile_use_name_prefix ? null : coalesce(each.value.instance_profile_name, "${each.value.iam_instance_profile}-profile")
  name_prefix = each.value.instance_profile_use_name_prefix ? "${coalesce(each.value.instance_profile_name, each.value.iam_instance_profile)}-profile-" : null
  path        = each.value.instance_profile_path
  role        = each.value.iam_instance_profile

  tags = merge(
    each.value.tags,
    each.value.instance_profile_tags,
    {
      Name = coalesce(each.value.instance_profile_name, "${each.value.iam_instance_profile}-profile")
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
