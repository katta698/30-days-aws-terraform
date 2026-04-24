# What I learned today

Today was about bringing discipline to variables.

Terraform allows flexibility by default, but in real-world projects, that flexibility can lead to:

Wrong inputs
Broken deployments
Security gaps

Type constraints solve that by making inputs predictable and validated.

# Basic Types

Terraform supports simple data types:

string → text values
number → integers or decimals
bool → true or false
Example
variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances"
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable monitoring or not"
}

# Collection Types

1. list(type)

Ordered values, duplicates allowed

variable "availability_zones" {
  type = list(string)
}
2. set(type)

Unordered, unique values only

variable "allowed_ips" {
  type = set(string)
}
3. map(type)

Key-value pairs

variable "tags" {
  type = map(string)
}

# Complex Types

tuple

Fixed structure, position matters

variable "server_config" {
  type = tuple([string, number, bool])
}
object

Structured and readable (used heavily in real projects)

variable "instance_config" {
  type = object({
    name           = string
    instance_type  = string
    volume_size    = number
    is_production  = bool
  })
}

# Type Validation

Terraform allows adding rules on top of types

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa, or prod."
  }
}

# Real-World Pattern I Practiced

1. Environment-based config
variable "env_config" {
  type = map(object({
    instance_type = string
    instance_count = number
  }))
}
2. Tag standardization
variable "common_tags" {
  type = map(string)
}
3. Network validation
variable "vpc_cidr" {
  type = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Invalid CIDR block."
  }
}

# Key Takeaways

Types are not optional in real projects
object is your best friend for structured configs
Validation blocks prevent costly mistakes
list vs set vs map matters more than it seems
Clean inputs = predictable infrastructure

# My Reflection

Today felt like moving from writing scripts to designing systems.

Earlier I was just passing values.
Now I’m defining contracts.

And that changes everything