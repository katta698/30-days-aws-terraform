############################################################
# Assignment 2: Resource Tagging
# Assignment 1: Project Naming (used via locals)
############################################################

resource "aws_vpc" "day11_vpc" {
  cidr_block           = "10.11.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${local.formatted_project_name}-vpc"
  })
}

############################################################
# Assignment 3: S3 Bucket Naming
############################################################

resource "aws_s3_bucket" "day11_bucket" {
  bucket = local.final_bucket_name

  tags = merge(local.common_tags, {
    Name = local.final_bucket_name
  })
}

############################################################
# Assignment 4: Security Group Ports
############################################################

resource "aws_security_group" "day11_sg" {
  name        = "${local.formatted_project_name}-sg"
  description = "Security group created using Terraform functions"
  vpc_id      = aws_vpc.day11_vpc.id

  dynamic "ingress" {
    for_each = local.allowed_ports_number

    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.formatted_project_name}-sg"
  })
}

############################################################
# Assignment 5: Environment Lookup
# Assignment 6: Instance Validation (validated in variables.tf)
############################################################

resource "aws_instance" "day11_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = local.selected_instance_size

  tags = merge(local.common_tags, {
    Name = "${local.formatted_project_name}-ec2"
  })
}

############################################################
# Assignment 11: Timestamp Management
############################################################

resource "aws_s3_bucket" "day12_bucket" {
  # Using timestamp() to make bucket name unique
  bucket = "jay-day12-${replace(timestamp(), ":", "-")}"

  tags = {
    # Using formatdate() for readable timestamp
    CreatedAt = local.formatted_time
  }
}

############################################################
# Assignment 12: Secrets Manager
############################################################

resource "aws_secretsmanager_secret" "config_secret" {
  name = "day12-config-secret"
}

resource "aws_secretsmanager_secret_version" "config_secret_value" {
  secret_id     = aws_secretsmanager_secret.config_secret.id
  secret_string = jsonencode(local.config_json)
}