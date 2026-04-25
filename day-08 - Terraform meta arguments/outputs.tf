output "count_bucket_names" {
  description = "S3 bucket names created using count"
  value       = [for bucket in aws_s3_bucket.count_demo : bucket.bucket]
}

output "count_bucket_ids" {
  description = "S3 bucket IDs created using count"
  value       = [for bucket in aws_s3_bucket.count_demo : bucket.id]
}

output "foreach_bucket_names" {
  description = "S3 bucket names created using for_each"
  value       = [for bucket in aws_s3_bucket.foreach_demo : bucket.bucket]
}

output "foreach_bucket_ids" {
  description = "S3 bucket IDs created using for_each"
  value       = [for bucket in aws_s3_bucket.foreach_demo : bucket.id]
}

output "foreach_bucket_map" {
  description = "Map showing for_each keys and bucket names"
  value = {
    for key, bucket in aws_s3_bucket.foreach_demo : key => bucket.bucket
  }
}