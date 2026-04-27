data "aws_vpc" "default" {
  default = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "demo" {
  count = local.bucket_count

  bucket = "${var.project_prefix}-${var.environment}-${count.index + 1}-${random_id.suffix.hex}"

  tags = merge(local.common_tags, {
    Name            = "${var.project_prefix}-${var.environment}-${count.index + 1}"
    EnvironmentType = local.environment_type
  })
}

resource "aws_s3_bucket_versioning" "demo" {
  count = local.bucket_count

  bucket = aws_s3_bucket.demo[count.index].id

  versioning_configuration {
    status = local.versioning_status
  }
}

resource "aws_security_group" "demo" {
  name        = "${var.project_prefix}-${var.environment}-sg-${random_id.suffix.hex}"
  description = "Security group created using Terraform dynamic blocks"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_prefix}-${var.environment}-sg"
  })
}