############################################################
# Day 11–12 Terraform Functions
# Variables grouped by assignments for clarity
############################################################

############################################################
# Assignment 1: Project Naming
############################################################

variable "project_name" {
  description = "Raw project name before formatting."
  type        = string
}

############################################################
# Assignment 2: Resource Tagging
############################################################

variable "owner" {
  description = "Owner tag value."
  type        = string
}

variable "department" {
  description = "Department tag value."
  type        = string
}

############################################################
# Assignment 3: S3 Bucket Naming
############################################################

variable "bucket_raw_name" {
  description = "Raw S3 bucket name before cleanup."
  type        = string
}

############################################################
# Assignment 4: Security Group Ports
############################################################

variable "allowed_ports_csv" {
  description = "Comma-separated list of ports for the security group."
  type        = string
}

############################################################
# Assignment 5: Environment Lookup
############################################################

variable "environment" {
  description = "Deployment environment such as dev, qa, or prod."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa, or prod."
  }
}

variable "instance_type_by_environment" {
  description = "Map of instance types by environment."
  type        = map(string)
}

############################################################
# Assignment 6: Instance Validation
############################################################

variable "selected_instance_type" {
  description = "Instance type to validate."
  type        = string

  validation {
    condition     = length(var.selected_instance_type) > 0 && can(regex("^[a-z][0-9][a-z]?\\.[a-z]+$", var.selected_instance_type))
    error_message = "Instance type must look like a valid AWS instance type, for example t3.micro or m5.large."
  }
}

############################################################
# Common / Global Variables
############################################################

variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
}

############################################################
# Assignment 7: Backup Configuration
############################################################

variable "backup_name" {
  description = "Backup name must end with -backup"
  type        = string

  validation {
    condition     = endswith(var.backup_name, "-backup")
    error_message = "Backup name must end with -backup"
  }
}

############################################################
# Assignment 8: File Path Processing
############################################################

variable "file_path" {
  description = "Path to a file"
  type        = string
}

############################################################
# Assignment 9: Location Management
############################################################

variable "primary_regions" {
  description = "Primary AWS regions"
  type        = list(string)
}

variable "secondary_regions" {
  description = "Secondary AWS regions"
  type        = list(string)
}

############################################################
# Assignment 10: Cost Calculation
############################################################

variable "monthly_costs" {
  description = "List of monthly costs"
  type        = list(number)
}

variable "credit" {
  description = "Credit amount to subtract from total cost"
  type        = number
}

############################################################
# Assignment 12: File Content Handling
############################################################

variable "config_file" {
  description = "Path to JSON config file"
  type        = string
}