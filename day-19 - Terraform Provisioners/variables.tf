variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "AWS EC2 Key Pair"
  type        = string
}

variable "private_key_path" {
  description = "Path to PEM file"
  type        = string
}