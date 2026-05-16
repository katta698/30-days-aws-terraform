#!/bin/bash
set -eux

dnf update -y
dnf install -y docker jq awscli
systemctl enable docker
systemctl start docker

SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id ${secret_name} \
  --region ${aws_region} \
  --query SecretString \
  --output text)

DB_HOST=$(echo $SECRET_JSON | jq -r .host)
DB_PORT=$(echo $SECRET_JSON | jq -r .port)
DB_NAME=$(echo $SECRET_JSON | jq -r .dbname)
DB_USER=$(echo $SECRET_JSON | jq -r .username)
DB_PASSWORD=$(echo $SECRET_JSON | jq -r .password)

docker pull ${backend_image}

docker run -d \
  --name backend \
  --restart always \
  -p 8080:8080 \
  -e DB_HOST="$DB_HOST" \
  -e DB_PORT="$DB_PORT" \
  -e DB_NAME="$DB_NAME" \
  -e DB_USER="$DB_USER" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  ${backend_image}