terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "day2-vpc"
    Environment = "learning"
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "jayanth-day2-${random_id.suffix.hex}"

  tags = {
    Name        = "day2-bucket"
    Environment = "learning"
  }
}