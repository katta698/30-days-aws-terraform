terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "katta"

    workspaces {
      name = "tf-cli"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "jay-day4-demo-bucket-123456"

  tags = {
    Name = "Day4 Demo Bucket"
    Env  = "Development"
  }
}