variable "project_name" {
  default = "day22-rds-project"
}

variable "environment" {
  default = "dev"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "db_name" {
  default = "appdb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default   = "Password123!"
  sensitive = true
}