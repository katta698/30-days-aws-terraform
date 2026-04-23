locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  })

  name_prefix = "${var.project_name}-${var.environment}"
  vpc_name    = "${local.name_prefix}-vpc"
  bucket_name = lower("${local.name_prefix}-${random_id.bucket_suffix.hex}")
}

resource "random_id" "bucket_suffix" {
  byte_length = 3

  keepers = {
    project     = var.project_name
    environment = var.environment
  }
}