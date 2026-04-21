# Day 4 - Terraform State File Management with Remote Backend

## Goal
Learn how Terraform stores state remotely in Amazon S3 and how state locking works using S3 native lockfiles.

## What this lab does
This lab creates one very small local file resource so I can safely test Terraform state behavior without creating expensive AWS infrastructure.

Terraform state itself is stored remotely in S3.

## Backend used
- Backend type: s3
- State locking: enabled with `use_lockfile = true`
- Encryption: enabled
- State path: `dev/terraform.tfstate`

## Why remote backend matters
- Team members can share the same state
- Terraform can lock state during apply
- State is stored more safely than on a laptop
- S3 versioning helps with recovery
- Access can be controlled with IAM

## Files in this folder
- `main.tf` -> Terraform configuration
- `terraform.tfvars` -> variable values if needed later
- `.terraform.lock.hcl` -> provider dependency lock file created by `terraform init`

## Before running
Make sure these are already available:
1. Terraform installed
2. AWS CLI configured
3. S3 bucket already created
4. S3 bucket versioning enabled
5. Bucket name updated in `main.tf`

## Commands to run

### 1. Initialize
```bash
terraform init