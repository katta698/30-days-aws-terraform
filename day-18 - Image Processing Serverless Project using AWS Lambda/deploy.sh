#!/usr/bin/env bash
set -euo pipefail

echo "Packaging Lambda and Pillow layer..."
bash scripts/package_lambda.sh

echo "Deploying Terraform..."
cd terraform

terraform init
terraform fmt
terraform validate
terraform apply -auto-approve

echo ""
echo "Deployment complete."
terraform output