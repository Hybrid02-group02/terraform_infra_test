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

# ROSA
cluster_name = "project02-rosa-cluster"
region  = "ap-northeast-2"
rosa_token = "eyJhbGciOiJIUzUxMiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI0NzQzYTkzMC03YmJiLTRkZGQtOTgzMS00ODcxNGRlZDc0YjUifQ.eyJpYXQiOjE3NDM5ODkxOTAsImp0aSI6IjBmMGQ1NzM4LTlmZGQtNDQ4OS04OWYyLWE3ZmRiOWZkNzhlYiIsImlzcyI6Imh0dHBzOi8vc3NvLnJlZGhhdC5jb20vYXV0aC9yZWFsbXMvcmVkaGF0LWV4dGVybmFsIiwiYXVkIjoiaHR0cHM6Ly9zc28ucmVkaGF0LmNvbS9hdXRoL3JlYWxtcy9yZWRoYXQtZXh0ZXJuYWwiLCJzdWIiOiJmOjUyOGQ3NmZmLWY3MDgtNDNlZC04Y2Q1LWZlMTZmNGZlMGNlNjp3ZW5keTA0MDgiLCJ0eXAiOiJPZmZsaW5lIiwiYXpwIjoiY2xvdWQtc2VydmljZXMiLCJub25jZSI6ImIxNmZiYzRjLTJmZmMtNGUxZS05ZTFhLWEzOGNhYzNmYTEyNSIsInNpZCI6ImUzZWI3NWZhLWEwM2MtNGUyNC05ODBiLWU3NTEzODNiN2ZlYiIsInNjb3BlIjoib3BlbmlkIGJhc2ljIGFwaS5pYW0uc2VydmljZV9hY2NvdW50cyByb2xlcyB3ZWItb3JpZ2lucyBjbGllbnRfdHlwZS5wcmVfa2MyNSBvZmZsaW5lX2FjY2VzcyJ9.iQOWZbFOVNpZeK-JZrip_4Yu_sZ2s6wQRSf-TZzJWVyIdsWsoDvKA1Y7z1qYurAUrHJKX3Cyw_z38kScLFA4uA"
