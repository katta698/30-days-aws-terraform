#!/usr/bin/env bash
set -euxo pipefail

apt-get update -y
apt-get install -y nginx

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $(curl -s -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600')" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $(curl -s -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600')" http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html>
<head>
  <title>${project_name} - ${environment}</title>
</head>
<body style="font-family: Arial; margin: 40px;">
  <h1>Day 27 AWS Production Infrastructure</h1>
  <p>Environment: ${environment}</p>
  <p>Served by EC2 instance: $INSTANCE_ID</p>
  <p>Availability Zone: $AZ</p>
  <p>Traffic path: Internet -> ALB -> Private EC2 Auto Scaling Group</p>
</body>
</html>
HTML

systemctl enable nginx
systemctl restart nginx
