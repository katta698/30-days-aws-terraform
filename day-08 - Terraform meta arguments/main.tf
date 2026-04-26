# -----------------------------
# COUNT EXAMPLE
# -----------------------------
resource "aws_s3_bucket" "count_demo" {
  count = length(var.count_buckets)

  bucket = "jay-day8-${var.count_buckets[count.index]}"

  tags = merge(local.common_tags, {
    Method = "count"
  })
}

# -----------------------------
# FOR_EACH EXAMPLE
# -----------------------------
resource "aws_s3_bucket" "foreach_demo" {
  for_each = var.foreach_buckets

  bucket = "jay-day8-${each.value}"

  tags = merge(local.common_tags, {
    Method = "for_each"
  })
}

# -----------------------------
# DEPENDS_ON EXAMPLE
# -----------------------------
resource "aws_s3_bucket" "dependent_bucket" {
  bucket = "jay-day8-dependent"

  depends_on = [aws_s3_bucket.count_demo]
}

# -----------------------------
# LIFECYCLE EXAMPLE
# -----------------------------
resource "aws_s3_bucket" "protected_bucket" {
  bucket = "jay-day8-protected"

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.common_tags, {
    Type = "protected"
  })
}

# -----------------------------
# PROVIDER EXAMPLE (Multi Region)
# -----------------------------
resource "aws_s3_bucket" "west_region_bucket" {
  provider = aws.west

  bucket = "jay-day8-west"

  tags = merge(local.common_tags, {
    Region = "west"
  })
}