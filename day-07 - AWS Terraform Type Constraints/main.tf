terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-07/type-constraints/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "day7_vpc" {
  cidr_block           = var.network_config.vpc_cidr
  enable_dns_support   = var.network_config.enable_dns
  enable_dns_hostnames = var.network_config.enable_dns

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_prefix}-${var.environment}-vpc-${var.unique_suffix}"
      Environment = var.environment
      Monitoring  = tostring(var.enable_monitoring)
      ServerName  = var.server_tuple[0]
      DiskSizeGB  = tostring(var.server_tuple[1])
      IsProd      = tostring(var.server_tuple[2])
    }
  )
}

resource "aws_subnet" "day7_subnets" {
  count = var.instance_count

  vpc_id            = aws_vpc.day7_vpc.id
  cidr_block        = var.network_config.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_prefix}-${var.environment}-subnet-${count.index + 1}-${var.unique_suffix}"
    }
  )
}

resource "aws_security_group" "day7_sg" {
  name        = "${var.project_prefix}-${var.environment}-sg-${var.unique_suffix}"
  description = "Security group created for Day 7 Terraform type constraints demo"
  vpc_id      = aws_vpc.day7_vpc.id

  dynamic "ingress" {
    for_each = var.allowed_ports

    content {
      description = "Allowed port ${ingress.value}"
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

  tags = merge(
    var.common_tags,
    {
      Name         = "${var.project_prefix}-${var.environment}-sg-${var.unique_suffix}"
      AllowedPorts = join(",", [for port in var.allowed_ports : tostring(port)])
    }
  )
}