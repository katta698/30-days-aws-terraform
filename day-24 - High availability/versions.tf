terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-24/dev/terraform.tfstate"
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