output "monitored_bucket_name" {
  value = module.log_ingest_s3.monitored_bucket_name
}

output "cloudtrail_name" {
  value = module.log_ingest_s3.cloudtrail_name
}

output "cloudwatch_log_group_name" {
  value = module.log_ingest_s3.cloudwatch_log_group_name
}

output "sns_topic_arn" {
  value = module.sns_security.sns_topic_arn
}