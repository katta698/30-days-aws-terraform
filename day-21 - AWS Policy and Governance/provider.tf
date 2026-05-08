terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-21/policy-governance/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}