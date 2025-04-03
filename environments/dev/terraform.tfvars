project_name         = "project02"
environment          = "project02"

ami_id               = "ami-0a463f27534bdf246"  #  실제 AWS 계정에 존재하는 AMI ID로 바꿔야 함
key_name             = "my-keypair"             #  AWS에 등록된 키 페어 이름
instance_type        = "t3.micro"

route53_domain_name  = "naddong.shop"      # 실제 도메인 이름 입력
route53_record_name  = "naddong.shop"

vpc_cidr             = "10.0.0.0/16"

public_subnet_cidrs  = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.101.0/24",
  "10.0.102.0/24"
]

azs = [
  "ap-northeast-2a",
  "ap-northeast-2c"
]