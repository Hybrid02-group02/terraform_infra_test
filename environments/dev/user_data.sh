#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sleep 3

echo "Hello from Terraform EC2 instance" | sudo tee /usr/share/nginx/html/index.html > /dev/null

