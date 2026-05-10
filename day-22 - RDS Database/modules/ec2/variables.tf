variable "project_name" {}
variable "environment" {}

variable "public_subnet_id" {}
variable "web_security_group" {}

variable "db_endpoint" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}