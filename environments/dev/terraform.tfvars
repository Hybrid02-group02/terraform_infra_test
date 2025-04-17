project_name = "project02"
environment  = "project02"

ami_id        = "ami-0a463f27534bdf246" #  실제 AWS 계정에 존재하는 AMI ID로 바꿔야 함
key_name      = "my-keypair"            #  AWS에 등록된 키 페어 이름
instance_type = "t3.micro"

route53_domain_name = "naddong.shop" # 실제 도메인 이름 입력
route53_record_name = "naddong.shop"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
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
region       = "ap-northeast-2"
rosa_token   = "eyJhbGciOiJIUzUxMiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI0NzQzYTkzMC03YmJiLTRkZGQtOTgzMS00ODcxNGRlZDc0YjUifQ.eyJpYXQiOjE3NDQ2OTIxNjgsImp0aSI6IjcxYjc4ZDBiLTU0MzMtNDNhNi05YjU0LWQ4MWEwMzdjMmFiZCIsImlzcyI6Imh0dHBzOi8vc3NvLnJlZGhhdC5jb20vYXV0aC9yZWFsbXMvcmVkaGF0LWV4dGVybmFsIiwiYXVkIjoiaHR0cHM6Ly9zc28ucmVkaGF0LmNvbS9hdXRoL3JlYWxtcy9yZWRoYXQtZXh0ZXJuYWwiLCJzdWIiOiJmOjUyOGQ3NmZmLWY3MDgtNDNlZC04Y2Q1LWZlMTZmNGZlMGNlNjp3ZW5keTA0MDgiLCJ0eXAiOiJPZmZsaW5lIiwiYXpwIjoiY2xvdWQtc2VydmljZXMiLCJub25jZSI6ImU5Mjg2ZWQ1LWY0NDUtNDJjYS1iOWNiLWI3ZWI3ZGE2NWM5YSIsInNpZCI6ImI3ODg3ZWUxLTQyY2UtNGQ5My1iZTUyLTQ1Y2EzNWI2NzhkMiIsInNjb3BlIjoib3BlbmlkIGJhc2ljIGFwaS5pYW0uc2VydmljZV9hY2NvdW50cyByb2xlcyB3ZWItb3JpZ2lucyBjbGllbnRfdHlwZS5wcmVfa2MyNSBvZmZsaW5lX2FjY2VzcyJ9.aGCx_WkAlZHOp-Wk5fNcUY3cvG-0nWCi7trqsDln4Cj9uEJUFejFRBuBRJKImnwAN-KW7_QFTwKaZ-Ati9BNAA"
