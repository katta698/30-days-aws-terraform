locals {
  common_tags = {
    Project     = var.project_name
    Owner       = "Jay"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Day         = "15"
  }
}