#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sleep 3

echo "Hello from Terraform EC2 instance" | sudo tee /usr/share/nginx/html/index.html > /dev/null

# ===== Grafana 설치 시작 =====

# Grafana yum 리포지터리 등록
sudo tee /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF

# Grafana 설치
sudo yum install -y grafana

# Grafana 서비스 실행 및 부팅 시 자동 시작 설정
sudo systemctl daemon-reexec
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
