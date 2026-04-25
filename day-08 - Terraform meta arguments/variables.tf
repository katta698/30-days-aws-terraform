variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
  default     = "us-east-1"
}

variable "project_prefix" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "jay-day8"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "count_bucket_names" {
  description = "Bucket names used for count example"
  type        = list(string)
  default     = ["count-one", "count-two"]
}

variable "foreach_bucket_names" {
  description = "Bucket names used for for_each example"
  type        = set(string)
  default     = ["foreach-one", "foreach-two"]
}