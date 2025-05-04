# Create the IAM role with a trust policy allowing EC2 to assume the role
resource "aws_iam_role" "full_access_mc_bedrock_backups" {
  name = "FullAccessMCBedrockBackups"  # Corrected the name here for consistency

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the custom inline policy to the IAM role
resource "aws_iam_role_policy" "full_access_mc_bedrock_backups_policy" {
  name   = "FullAccessMCBedrockBackupsPolicy"  # Updated name for consistency
  role   = aws_iam_role.full_access_mc_bedrock_backups.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect  = "Allow"
        Action  = "s3:*"
        Resource = "*"
      },
      {
        Effect  = "Allow"
        Action  = "s3:*"
        Resource = [
          "arn:aws:s3:::mc-bedrock-backup",
          "arn:aws:s3:::mc-bedrock-backup/*"
          ]
      }
    ]
  })
}

# Create the IAM instance profile to attach the role to EC2 instance
resource "aws_iam_instance_profile" "instance_profile" {
  name = "FullAccessMCBedrockBackupsInstanceProfile"
  role = aws_iam_role.full_access_mc_bedrock_backups.name
}

