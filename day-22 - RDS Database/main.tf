terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day22/dev/terraform.tfstate"
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
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "rds" {
  source = "./modules/rds"

  project_name      = var.project_name
  environment       = var.environment
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  private_subnet_ids = module.vpc.private_subnet_ids
  db_security_group = module.security_groups.db_sg_id
}

module "ec2" {
  source = "./modules/ec2"

  project_name         = var.project_name
  environment          = var.environment
  public_subnet_id     = module.vpc.public_subnet_id
  web_security_group   = module.security_groups.web_sg_id
  db_endpoint          = module.rds.db_endpoint
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
}