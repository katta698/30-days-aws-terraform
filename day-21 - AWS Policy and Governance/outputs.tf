output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "config_bucket_name" {
  value = aws_s3_bucket.config_bucket.bucket
}

output "config_recorder_name" {
  value = aws_config_configuration_recorder.main.name
}

output "config_delivery_channel" {
  value = aws_config_delivery_channel.main.name
}

output "demo_user_name" {
  value = aws_iam_user.demo_user.name
}

output "config_rules" {
  value = [
    aws_config_config_rule.s3_public_write_prohibited.name,
    aws_config_config_rule.s3_encryption_enabled.name,
    aws_config_config_rule.s3_public_read_prohibited.name,
    aws_config_config_rule.ebs_volumes_encrypted.name,
    aws_config_config_rule.required_tags.name,
    aws_config_config_rule.iam_password_policy.name,
    aws_config_config_rule.root_mfa_enabled.name
  ]
}

output "test_commands" {
  value = <<EOT
aws configservice describe-configuration-recorders
aws configservice describe-delivery-channels
aws configservice describe-config-rules
aws configservice describe-compliance-by-config-rule
aws s3api get-bucket-encryption --bucket ${aws_s3_bucket.config_bucket.bucket}
aws s3api get-public-access-block --bucket ${aws_s3_bucket.config_bucket.bucket}
EOT
}