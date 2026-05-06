output "upload_bucket_name" {
  value = aws_s3_bucket.upload_bucket.bucket
}

output "processed_bucket_name" {
  value = aws_s3_bucket.processed_bucket.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.image_processor.function_name
}

output "upload_command" {
  value = "aws s3 cp ../sample.jpg s3://${aws_s3_bucket.upload_bucket.bucket}/sample.jpg"
}

output "list_processed_command" {
  value = "aws s3 ls s3://${aws_s3_bucket.processed_bucket.bucket}/ --recursive"
}

output "logs_command" {
  value = "MSYS_NO_PATHCONV=1 aws logs tail /aws/lambda/${aws_lambda_function.image_processor.function_name} --region ${var.aws_region} --since 30m"
}