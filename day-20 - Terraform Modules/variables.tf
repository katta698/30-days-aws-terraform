variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "day20-eks-cluster"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.30"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24", "10.20.13.0/24"]
}

variable "enable_db_secret" {
  type    = bool
  default = false
}

variable "enable_api_secret" {
  type    = bool
  default = false
}

variable "enable_app_config_secret" {
  type    = bool
  default = false
}

variable "db_username" {
  type      = string
  default   = ""
  sensitive = true
}

variable "db_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_host" {
  type    = string
  default = ""
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "db_name" {
  type    = string
  default = ""
}

variable "api_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "api_secret" {
  type      = string
  default   = ""
  sensitive = true
}

variable "app_config" {
  type    = map(string)
  default = {}
}