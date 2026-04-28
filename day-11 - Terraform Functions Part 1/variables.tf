variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
}

variable "project_name" {
  description = "Raw project name before formatting."
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, qa, or prod."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa, or prod."
  }
}

variable "owner" {
  description = "Owner tag value."
  type        = string
}

variable "department" {
  description = "Department tag value."
  type        = string
}

variable "bucket_raw_name" {
  description = "Raw S3 bucket name before cleanup."
  type        = string
}

variable "allowed_ports_csv" {
  description = "Comma-separated list of ports for the security group."
  type        = string
}

variable "instance_type_by_environment" {
  description = "Map of instance types by environment."
  type        = map(string)
}

variable "selected_instance_type" {
  description = "Instance type to validate."
  type        = string

  validation {
    condition     = length(var.selected_instance_type) > 0 && can(regex("^[a-z][0-9][a-z]?\\.[a-z]+$", var.selected_instance_type))
    error_message = "Instance type must look like a valid AWS instance type, for example t3.micro or m5.large."
  }
}