output "alb_dns_name" {
  value       = aws_lb.web_alb.dns_name
  description = "Public URL for checking our running cluster web application."
}
