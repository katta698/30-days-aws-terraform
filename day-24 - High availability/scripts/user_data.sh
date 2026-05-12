#!/bin/bash
exec > /var/log/day24-user-data.log 2>&1
set -x

yum update -y
amazon-linux-extras install docker -y

systemctl enable docker
systemctl start docker

sleep 45

docker pull itsbaivab/django-app

docker rm -f django-app || true

docker run -d \
  --name django-app \
  --restart always \
  -p 8000:8000 \
  itsbaivab/django-app

sleep 15
docker ps