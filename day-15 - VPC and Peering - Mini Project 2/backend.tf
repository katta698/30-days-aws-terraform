terraform {
  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-15/vpc-peering/terraform.tfstate"
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