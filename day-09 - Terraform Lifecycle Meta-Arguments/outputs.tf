output "zero_downtime_bucket_name" {
  value = aws_s3_bucket.zero_downtime_bucket.bucket
}

output "protected_bucket_name" {
  value = aws_s3_bucket.protected_bucket.bucket
}

output "ignore_changes_bucket_name" {
  value = aws_s3_bucket.ignore_changes_bucket.bucket
}

output "replace_trigger_bucket_name" {
  value = aws_s3_bucket.replace_trigger_bucket.bucket
}

output "precondition_bucket_name" {
  value = aws_s3_bucket.precondition_bucket.bucket
}

output "postcondition_bucket_name" {
  value = aws_s3_bucket.postcondition_bucket.bucket
}