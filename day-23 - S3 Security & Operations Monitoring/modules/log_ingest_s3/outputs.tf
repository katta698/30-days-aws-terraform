output "monitored_bucket_name" {
  value = aws_s3_bucket.monitored.bucket
}

output "monitored_bucket_arn" {
  value = aws_s3_bucket.monitored.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.cloudtrail.name
}

output "cloudtrail_name" {
  value = aws_cloudtrail.s3_data_events.name
}