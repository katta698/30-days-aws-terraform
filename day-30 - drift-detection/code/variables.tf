variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Target execution environment (dev or prod)"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
