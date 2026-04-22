locals {
  common_tags = {
    Environment = var.environment
    Project     = "VariablesDemo-Jay"
  }

  full_bucket_name = "${var.environment}-${var.bucket_name}-${random_string.suffix.result}"
}