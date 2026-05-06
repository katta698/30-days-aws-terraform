#!/usr/bin/env bash
set -euo pipefail

cd terraform

UPLOAD_BUCKET=$(terraform output -raw upload_bucket_name || true)
PROCESSED_BUCKET=$(terraform output -raw processed_bucket_name || true)

empty_versioned_bucket() {
  local BUCKET_NAME="$1"

  if [ -z "$BUCKET_NAME" ]; then
    return
  fi

  echo "Emptying bucket: $BUCKET_NAME"

  aws s3 rm "s3://$BUCKET_NAME" --recursive || true

  aws s3api list-object-versions \
    --bucket "$BUCKET_NAME" \
    --query 'Versions[].{Key:Key,VersionId:VersionId}' \
    --output json > versions.json || true

  if [ -s versions.json ] && [ "$(cat versions.json)" != "null" ] && [ "$(cat versions.json)" != "[]" ]; then
    aws s3api delete-objects \
      --bucket "$BUCKET_NAME" \
      --delete "{\"Objects\":$(cat versions.json),\"Quiet\":true}" || true
  fi

  aws s3api list-object-versions \
    --bucket "$BUCKET_NAME" \
    --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' \
    --output json > delete-markers.json || true

  if [ -s delete-markers.json ] && [ "$(cat delete-markers.json)" != "null" ] && [ "$(cat delete-markers.json)" != "[]" ]; then
    aws s3api delete-objects \
      --bucket "$BUCKET_NAME" \
      --delete "{\"Objects\":$(cat delete-markers.json),\"Quiet\":true}" || true
  fi

  rm -f versions.json delete-markers.json
}

empty_versioned_bucket "$UPLOAD_BUCKET"
empty_versioned_bucket "$PROCESSED_BUCKET"

terraform destroy -auto-approve