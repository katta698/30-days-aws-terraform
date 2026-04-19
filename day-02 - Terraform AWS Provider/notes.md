# Day 2 - Terraform AWS Provider

## What I Learned

Today I explored Terraform Providers and how they enable Terraform to interact with AWS.

## Terraform Provider

A Terraform provider acts as a bridge between Terraform and cloud platforms like AWS.

- Terraform itself does not create resources directly  
- Providers communicate with cloud APIs  
- Example: `hashicorp/aws` provider is used for AWS  

## Terraform Core vs Provider Version

There are two types of versions:

- **Terraform Core Version**: The main Terraform binary
- **Provider Version**: Plugin used to interact with a specific platform (AWS, Azure, etc.)

Providers can come from:
- HashiCorp (official providers)
- Third-party sources
- Utility providers like `random`

## Version Behavior

- If no Terraform version is specified, Terraform may use the latest version available
- If no provider version is specified, Terraform downloads the latest compatible provider

This can lead to unexpected changes in behavior.

## Why Version Matters

Versioning is important for:

- Compatibility between Terraform and provider
- Stability across environments
- Avoiding breaking changes
- Reproducibility of infrastructure
- Access to new features and bug fixes

## Version Constraints and Operators

Terraform supports version constraints:

- `= 1.2.3` → exact version  
- `>= 1.2` → greater than or equal  
- `<= 1.2` → less than or equal  
- `~> 1.2` → allows safe updates within a version range  
- `>= 1.2, < 2.0` → range constraint  

The `~>` operator is commonly used to allow patch updates while avoiding major breaking changes.

## AWS Provider Example

Example of defining AWS provider:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}