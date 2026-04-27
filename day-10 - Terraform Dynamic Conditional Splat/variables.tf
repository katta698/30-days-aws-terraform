variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa, or prod."
  }
}

variable "project_prefix" {
  description = "Project prefix for naming resources"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
}

variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}