variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "day29-jay-gitops"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "cluster_version" {
  type    = string
  default = "1.31"
}

variable "owner" {
  type    = string
  default = "jay"
}