terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# optional second provider (for learning)
provider "aws" {
  alias  = "west"
  region = "us-west-1"
}