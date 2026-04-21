
---

## `main.tf`

This uses the `local` provider to create a tiny text file, while storing the Terraform **state** remotely in S3.

```hcl
terraform {
  required_version = ">= 1.10.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-04/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "local" {}

locals {
  file_name = "${path.module}/day4-demo.txt"
  message   = "Hello from Terraform Day 4 - remote backend test"
}

resource "local_file" "day4_demo" {
  filename = local.file_name
  content  = local.message
}

output "created_file" {
  value = local_file.day4_demo.filename
}

output "file_content" {
  value = local_file.day4_demo.content
}