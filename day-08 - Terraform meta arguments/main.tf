resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "count_demo" {
  count = length(var.count_bucket_names)

  bucket = "${var.project_prefix}-${var.environment}-${var.count_bucket_names[count.index]}-${random_string.suffix.result}"

  tags = {
    Name        = "${var.project_prefix}-${var.count_bucket_names[count.index]}"
    Environment = var.environment
    Method      = "count"
    Owner       = "Jay"
  }
}

resource "aws_s3_bucket" "foreach_demo" {
  for_each = var.foreach_bucket_names

  bucket = "${var.project_prefix}-${var.environment}-${each.value}-${random_string.suffix.result}"

  tags = {
    Name        = "${var.project_prefix}-${each.value}"
    Environment = var.environment
    Method      = "for_each"
    Owner       = "Jay"
  }
}