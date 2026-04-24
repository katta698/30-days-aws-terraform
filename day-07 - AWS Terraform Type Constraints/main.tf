terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-07/type-constraints-full-demo/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Example resource using multiple data types
resource "aws_s3_bucket" "jay_day7_bucket" {
  bucket = "${var.project_prefix}-${var.environment}-${var.unique_suffix}"

  tags = merge(
    var.common_tags,
    {
      Owner        = "Jayanth-Katta"
      Environment  = var.environment
      Monitoring   = tostring(var.enable_monitoring)
    }
  )
}