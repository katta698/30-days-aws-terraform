variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "day28-3tier"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "frontend_image" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "db_username" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "my_ip_cidr" {
  type        = string
  description = "Your public IP CIDR for bastion SSH, example 1.2.3.4/32"
}