resource "aws_instance" "ansible_host" {
  ami             = var.ami_id
  instance_type   = "t3.small"
  subnet_id       = var.ec2_subnet_id
  key_name        = var.key_name
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  # EC2 시작 시 Ansible 및 플레이북 자동 실행
  user_data = <<EOF
#!/bin/bash
# 시스템 업데이트 및 필수 패키지 설치
sudo yum update -y
sudo yum install -y ansible git

# Ansible 플레이북 다운로드 (GitHub 또는 S3에서 가져오기)
sudo git clone https://github.com/your-repo/ansible-playbooks.git /home/ec2-user/ansible

# ROSA CLI 다운로드 및 설치
curl -O https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/rosa-linux.tar.gz
tar -xvzf rosa-linux.tar.gz
chmod +x rosa
sudo mv rosa /usr/local/bin/

# ROSA CLI 확인
rosa version

# Ansible 실행 준비
cd /home/ec2-user/ansible
ansible-playbook assign_users.yaml
ansible-playbook network_policy.yaml
EOF

  tags = {
    Name = "Ansible-Host"
  }
}

resource "aws_security_group" "ansible_sg" {
  name   = "${var.cluster_name}-ansible-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
