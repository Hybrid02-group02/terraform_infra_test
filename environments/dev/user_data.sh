#!/bin/bash
sudo apt update -y
sudo apt install -y nginx
echo "Hello from Terraform EC2 instance" > /var/www/html/index.html

