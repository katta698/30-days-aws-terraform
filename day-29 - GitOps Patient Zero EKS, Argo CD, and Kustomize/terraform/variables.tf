variable "aws_region" {
  description = "AWS region for Day 29 GitOps project"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "day29-jay-gitops"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.33"
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "jay"
}