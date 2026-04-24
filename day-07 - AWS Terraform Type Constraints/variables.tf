# -----------------------
# BASIC TYPES
# -----------------------

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "project_prefix" {
  type        = string
  description = "Project prefix"
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa, or prod."
  }
}

variable "unique_suffix" {
  type        = string
  description = "Unique suffix for resources"
}

variable "instance_count" {
  type        = number
  description = "Number of instances to simulate scaling logic"
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable monitoring flag"
}

# -----------------------
# COLLECTION TYPES
# -----------------------

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs"
}

variable "allowed_ports" {
  type        = set(number)
  description = "Set of allowed ports (no duplicates)"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

# -----------------------
# COMPLEX TYPES
# -----------------------

variable "server_tuple" {
  type        = tuple([string, number, bool])
  description = "Tuple: name, disk size, is production"
}

variable "network_config" {
  type = object({
    vpc_cidr     = string
    subnet_cidrs = list(string)
    enable_dns   = bool
  })

  validation {
    condition     = can(cidrnetmask(var.network_config.vpc_cidr))
    error_message = "Invalid VPC CIDR block."
  }
}