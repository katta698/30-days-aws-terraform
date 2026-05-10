variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
  default     = "day23-s3-security-monitoring"
}

variable "security_alert_email" {
  description = "Email address to receive security alerts"
  type        = string
}