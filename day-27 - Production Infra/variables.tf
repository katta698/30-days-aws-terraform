variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used in resource naming"
  type        = string
  default     = "day27-prod-infra"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "owner" {
  description = "Owner tag value"
  type        = string
  default     = "jay"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.27.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.27.1.0/24", "10.27.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.27.11.0/24", "10.27.12.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "ASG minimum size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "ASG maximum size"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}
