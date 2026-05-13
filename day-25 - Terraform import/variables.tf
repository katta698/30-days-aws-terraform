variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "existing_bucket_name" {
  description = "Existing S3 bucket name created manually"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the existing security group exists"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the existing EC2 instance exists"
  type        = string
}

variable "existing_instance_ami" {
  description = "AMI ID used by the existing EC2 instance"
  type        = string
}

variable "existing_instance_type" {
  description = "Instance type used by the existing EC2 instance"
  type        = string
  default     = "t2.micro"
}