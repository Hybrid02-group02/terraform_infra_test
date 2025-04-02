resource "aws_instance" "main" { # EC2 인스턴스 생성
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip

  user_data = var.user_data

  tags = {
    Name        = "${var.project_name}-${var.name}"
    Environment = var.environment
  }
}

