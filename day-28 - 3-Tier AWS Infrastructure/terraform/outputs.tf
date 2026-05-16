output "public_alb_url" {
  value = "http://${aws_lb.public.dns_name}"
}

output "internal_alb_dns" {
  value = aws_lb.internal.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "secret_name" {
  value = aws_secretsmanager_secret.db.name
}