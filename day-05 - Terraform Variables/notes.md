# Day 5 - Terraform Variables and Value Precedence

# Goal

Understand how Terraform variables work and how values are passed, combined, and prioritized during execution.

# What this lab does

This lab creates a simple S3 bucket using variables instead of hardcoded values.

It demonstrates how Terraform builds values dynamically using input variables, local variables, and outputs.

# Concepts covered
Input variables
Local variables
Output variables
Variable precedence

# Why variables matter
Avoid hardcoding values
Make configurations reusable
Support multiple environments
Improve readability and structure
Allow dynamic resource naming

# Files in this folder
variables.tf -> defines input variables
locals.tf -> builds computed values like final bucket name
main.tf -> creates S3 bucket resource
output.tf -> displays values after apply
terraform.tfvars -> default variable values
dev.tfvars -> values for development environment
production.tfvars -> values for production environment

# How values flow

Terraform processes values in this order:

input variables → local variables → resources → outputs

# Example behavior

Input values:

environment = test
bucket_name = jay-demo

Local builds final value:

test jay demo randomsuffix

Resource uses this final value to create the bucket.

# Variable precedence

Terraform uses values in this priority order:

# Command line arguments
tfvars files
Environment variables
Default values in variables.tf

# Tests performed
# 1. Using terraform.tfvars

Ran:

terraform plan

Terraform automatically picked values from terraform.tfvars.

# 2. Using default values

Temporarily removed terraform.tfvars and ran plan.

Terraform used default values from variables.tf.

# 3. Command line override

Ran:

terraform plan -var="environment=qa" -var="bucket_name=reports"

Command line values overrode all other inputs.

# 4. Environment variable

Set environment variable and ran plan.

Terraform used environment variable value.

Unset variable to test defaults again.

# 5. Using different tfvars files

Ran:

terraform plan -var-file="dev.tfvars"
terraform plan -var-file="production.tfvars"

Terraform used values from specified files.

# 6. Apply and verify outputs

Ran:

terraform apply
terraform output

Verified bucket name, environment, and tags.

# 7. Destroy resources

Ran:

terraform destroy

Cleaned up resources.

# Key observations
terraform.tfvars is automatically loaded
Command line overrides everything
Environment variables can override silently
Different tfvars files simulate environments
Some values are only known after apply

# Commands used
terraform init
terraform plan
terraform apply
terraform output
terraform destroy