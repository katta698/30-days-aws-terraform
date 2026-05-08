resource "aws_iam_role" "config_role" {
  name = "${var.project_name}-aws-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config_role_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_iam_user" "demo_user" {
  name = "${var.project_name}-demo-user"

  tags = {
    Environment = var.environment
    Owner       = var.owner
    Purpose     = "Policy testing"
  }
}

resource "aws_iam_policy" "s3_mfa_delete_policy" {
  name        = "${var.project_name}-s3-mfa-delete-policy"
  description = "Deny S3 object delete actions unless MFA is present"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyDeleteWithoutMFA"
        Effect = "Deny"
        Action = [
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_secure_transport_policy" {
  name        = "${var.project_name}-s3-secure-transport-policy"
  description = "Deny S3 access over insecure transport"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyInsecureS3Access"
        Effect   = "Deny"
        Action   = "s3:*"
        Resource = "*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "required_tags_policy" {
  name        = "${var.project_name}-required-tags-policy"
  description = "Require Environment and Owner tags when creating supported resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyEC2RunInstancesWithoutRequiredTags"
        Effect = "Deny"
        Action = [
          "ec2:RunInstances",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot"
        ]
        Resource = "*"
        Condition = {
          Null = {
            "aws:RequestTag/Environment" = "true"
            "aws:RequestTag/Owner"       = "true"
          }
        }
      },
      {
        Sid    = "DenyTagDeleteForRequiredTags"
        Effect = "Deny"
        Action = [
          "ec2:DeleteTags"
        ]
        Resource = "*"
        Condition = {
          "ForAnyValue:StringEquals" = {
            "aws:TagKeys" = [
              "Environment",
              "Owner"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_mfa_delete_policy" {
  user       = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.s3_mfa_delete_policy.arn
}

resource "aws_iam_user_policy_attachment" "attach_secure_transport_policy" {
  user       = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.s3_secure_transport_policy.arn
}

resource "aws_iam_user_policy_attachment" "attach_required_tags_policy" {
  user       = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.required_tags_policy.arn
}

resource "aws_iam_account_password_policy" "strict_password_policy" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 5
}