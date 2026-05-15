# Day 27 - AWS Production Infrastructure with Terraform and GitHub Actions

This project deploys a production-style two-tier AWS architecture using Terraform.

## Components

- VPC across two Availability Zones
- Public and private subnets
- Internet Gateway and NAT Gateway
- Application Load Balancer
- Auto Scaling Group with private EC2 instances
- Launch Template with Nginx bootstrap
- S3 bucket with encryption, versioning, and public access block
- GitHub Actions workflow for Terraform CI/CD

## Local Deployment

```bash
./scripts/create-backend-bucket.sh jay-terraformstate-bucket us-east-1
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
./scripts/validate.sh
```

## Cleanup

```bash
terraform destroy
```
