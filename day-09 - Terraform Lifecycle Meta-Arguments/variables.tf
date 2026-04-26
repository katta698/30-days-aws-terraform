variable "aws_region" {
  description = "AWS region for Day 09"
  type        = string
  default     = "us-east-1"
}

variable "project_prefix" {
  description = "Project prefix"
  type        = string
  default     = "jay-day9-lifecycle"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "allowed_regions" {
  description = "Allowed deployment regions"
  type        = list(string)
  default     = ["us-east-1", "us-east-2"]
}