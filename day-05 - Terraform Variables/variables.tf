variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "s3 bucket name"
  type        = string
  default     = "jay-storage"
}