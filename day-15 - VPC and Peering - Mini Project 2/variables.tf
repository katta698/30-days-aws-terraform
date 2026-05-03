variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "day15-vpc-peering"
}

variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region"
  type        = string
  default     = "us-west-2"
}

variable "primary_vpc_cidr" {
  description = "CIDR block for primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for secondary VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "primary_subnet_cidr" {
  description = "CIDR block for primary public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "secondary_subnet_cidr" {
  description = "CIDR block for secondary public subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "key_name" {
  description = "Existing EC2 key pair name in both regions"
  type        = string
}

variable "my_public_ip" {
  description = "Your public IP for SSH access. Example: 12.50.200.114/32"
  type        = string
}