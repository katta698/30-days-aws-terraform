#!/bin/bash
set -eux

dnf update -y
dnf install -y docker
systemctl enable docker
systemctl start docker

docker pull ${frontend_image}

docker run -d \
  --name frontend \
  --restart always \
  -p 3000:3000 \
  -e BACKEND_URL="${backend_internal_url}" \
  ${frontend_image}