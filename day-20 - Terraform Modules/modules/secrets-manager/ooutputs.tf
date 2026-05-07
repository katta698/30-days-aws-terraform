output "db_secret_arn" {
  value = try(aws_secretsmanager_secret.db[0].arn, null)
}

output "api_secret_arn" {
  value = try(aws_secretsmanager_secret.api[0].arn, null)
}

output "app_config_secret_arn" {
  value = try(aws_secretsmanager_secret.app_config[0].arn, null)
}