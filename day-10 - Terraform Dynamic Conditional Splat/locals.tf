locals {
  bucket_count = var.environment == "prod" ? 2 : 1

  versioning_status = var.enable_versioning ? "Enabled" : "Suspended"

  environment_type = var.environment == "prod" ? "production" : "non-production"

  common_tags = {
    Project     = var.project_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
    Day         = "10"
    Topic       = "Dynamic Blocks Conditional Expressions Splat Expressions"
  }
}