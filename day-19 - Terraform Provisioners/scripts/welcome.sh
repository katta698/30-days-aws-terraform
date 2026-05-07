#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install nginx1 -y

sudo systemctl enable nginx
sudo systemctl start nginx

echo "<h1>Terraform Provisioners Demo Successful</h1>" | sudo tee /usr/share/nginx/html/index.html