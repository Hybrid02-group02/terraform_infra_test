terraform {
  backend "s3" {
    bucket         = "project02-terraform-state-bucket" # 실제 s3 버킷 이름
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks" # DynamoDB 테이블
    encrypt        = true
  }
}
