#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_PATH="$ROOT_DIR/sample.jpg"

if [ ! -f "$IMAGE_PATH" ]; then
  echo "sample.jpg not found."
  echo "Place your image here:"
  echo "$ROOT_DIR/sample.jpg"
  exit 1
fi

cd "$ROOT_DIR/terraform"

UPLOAD_BUCKET=$(terraform output -raw upload_bucket_name)
PROCESSED_BUCKET=$(terraform output -raw processed_bucket_name)

echo "Uploading sample image..."
aws s3 cp "$IMAGE_PATH" "s3://$UPLOAD_BUCKET/sample-$(date +%Y%m%d%H%M%S).jpg"

echo "Waiting for Lambda..."
sleep 20

echo "Processed bucket files:"
aws s3 ls "s3://$PROCESSED_BUCKET/" --recursive