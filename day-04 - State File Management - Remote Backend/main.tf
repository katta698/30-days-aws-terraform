terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-04/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "jay-day4-demo-bucket-123456"  # MUST be globally unique

  tags = {
    Name = "Day4 Demo Bucket"
    Env = "Development"
  }
}