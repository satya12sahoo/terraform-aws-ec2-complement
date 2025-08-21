# =============================================================================
# IAM MODULE - Instance Profile for Existing IAM Role
# =============================================================================

# Create instance profile for existing IAM role
resource "aws_iam_instance_profile" "existing_role_profile" {
  count = var.create_instance_profile ? 1 : 0

  name = var.instance_profile_name
  path = var.instance_profile_path
  role = var.iam_role_name

  tags = merge(
    var.common_tags,
    var.instance_profile_tags,
    {
      Name = var.instance_profile_name
      Description = var.instance_profile_description
      Module = "iam"
      RotationEnabled = var.enable_instance_profile_rotation
    }
  )
}
