variable "project_name" {
  description = "Project name used for alarm names"
  type        = string
}

variable "metric_namespace" {
  description = "CloudWatch metric namespace"
  type        = string
}

variable "denied_metric_name" {
  description = "Metric name for denied requests"
  type        = string
}

variable "restricted_metric_name" {
  description = "Metric name for restricted prefix access"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for alarm notifications"
  type        = string
}