terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-25/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "imported_bucket" {
  bucket = var.existing_bucket_name

  tags = {
    Name        = var.existing_bucket_name
    Project     = "Day25TerraformImport"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}

resource "aws_security_group" "imported_sg" {
  name        = "day25-import-sg"
  description = "Created manually"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "day25-import-sg"
    Project     = "Day25TerraformImport"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}

resource "aws_instance" "imported_ec2" {
  ami                         = var.existing_instance_ami
  instance_type               = var.existing_instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.imported_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "day25-import-ec2"
    Project     = "Day25TerraformImport"
    ManagedBy   = "Terraform"
    Environment = "dev"
    owner       = "katta"
  }
}