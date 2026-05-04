resource "random_id" "suffix" {
  byte_length = 4
}

data "aws_elastic_beanstalk_solution_stack" "nodejs" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux 2023 .* running Node.js .*"
}

resource "aws_s3_bucket" "app_bucket" {
  bucket        = "${var.app_name}-artifacts-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Project   = "BlueGreenDeployment"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_object" "app_v1" {
  bucket      = aws_s3_bucket.app_bucket.id
  key         = "app-v1.zip"
  source      = "${path.module}/app-v1/app-v1.zip"
  source_hash = filemd5("${path.module}/app-v1/app-v1.zip")
}

resource "aws_s3_object" "app_v2" {
  bucket      = aws_s3_bucket.app_bucket.id
  key         = "app-v2.zip"
  source      = "${path.module}/app-v2/app-v2.zip"
  source_hash = filemd5("${path.module}/app-v2/app-v2.zip")
}

resource "aws_elastic_beanstalk_application" "app" {
  name        = var.app_name
  description = "Blue Green deployment demo using Terraform"

  tags = {
    Project   = "BlueGreenDeployment"
    ManagedBy = "Terraform"
  }
}

resource "aws_elastic_beanstalk_application_version" "v1" {
  name        = "app-v1-${random_id.suffix.hex}"
  application = aws_elastic_beanstalk_application.app.name
  bucket      = aws_s3_bucket.app_bucket.id
  key         = aws_s3_object.app_v1.key

  depends_on = [aws_s3_object.app_v1]
}

resource "aws_elastic_beanstalk_application_version" "v2" {
  name        = "app-v2-${random_id.suffix.hex}"
  application = aws_elastic_beanstalk_application.app.name
  bucket      = aws_s3_bucket.app_bucket.id
  key         = aws_s3_object.app_v2.key

  depends_on = [aws_s3_object.app_v2]
}

resource "aws_iam_role" "eb_service_role" {
  name = "${var.app_name}-eb-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_service_health" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "eb_service_managed_updates" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}

resource "aws_iam_role" "eb_ec2_role" {
  name = "${var.app_name}-eb-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "${var.app_name}-eb-instance-profile"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "my-blue-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.nodejs.name
  version_label       = aws_elastic_beanstalk_application_version.v1.name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.micro"
  }

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Blue"
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eb_service_health,
    aws_iam_role_policy_attachment.eb_service_managed_updates,
    aws_iam_role_policy_attachment.eb_web_tier
  ]
}

resource "aws_elastic_beanstalk_environment" "green" {
  name                = "my-green-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.nodejs.name
  version_label       = aws_elastic_beanstalk_application_version.v2.name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.micro"
  }

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Green"
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eb_service_health,
    aws_iam_role_policy_attachment.eb_service_managed_updates,
    aws_iam_role_policy_attachment.eb_web_tier
  ]
}