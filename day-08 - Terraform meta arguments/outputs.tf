output "count_bucket_names" {
  value = [for b in aws_s3_bucket.count_demo : b.bucket]
}

output "foreach_bucket_names" {
  value = [for b in aws_s3_bucket.foreach_demo : b.bucket]
}

output "foreach_map" {
  value = {
    for key, b in aws_s3_bucket.foreach_demo : key => b.id
  }
}