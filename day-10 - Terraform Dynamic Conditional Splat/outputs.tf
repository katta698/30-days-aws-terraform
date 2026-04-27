output "environment_type" {
  description = "Shows conditional expression result"
  value       = local.environment_type
}

output "bucket_names" {
  description = "Splat expression showing all bucket names"
  value       = aws_s3_bucket.demo[*].bucket
}

output "bucket_arns" {
  description = "Splat expression showing all bucket ARNs"
  value       = aws_s3_bucket.demo[*].arn
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.demo.id
}

output "configured_ingress_ports" {
  description = "Ports configured using dynamic blocks"
  value       = var.ingress_rules[*].from_port
}