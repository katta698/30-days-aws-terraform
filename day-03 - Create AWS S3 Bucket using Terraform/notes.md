# Day 3 – AWS S3 Bucket with Terraform

## What I Learned

- Terraform needs AWS credentials to interact with AWS APIs
- Authentication can be done using:
  - aws configure (AWS CLI)
  - Environment variables
  - IAM roles
  - Named profiles

## S3 Basics

- S3 = Simple Storage Service (object storage)
- Used to store files like images, backups, logs, etc.
- Bucket names must be:
  - Globally unique
  - Lowercase only
  - No spaces

## What I Did

- Configured AWS credentials using:
  aws configure

- Created a simple Terraform file:
  main.tf

- Created an S3 bucket using Terraform

## Terraform Commands Used

terraform init
terraform plan
terraform apply
#terraform destroy

## Issues Faced

- Error: No valid credential sources found
  Fix:
  - Ran aws configure
  - Verified using aws sts get-caller-identity

## Key Takeaway

Before writing Terraform code, authentication must be correct.
Most errors happen before infrastructure is even created.
