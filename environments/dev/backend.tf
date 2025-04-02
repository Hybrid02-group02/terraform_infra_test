terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-bucket-20250402" # 실제 s3 버킷 이름으로 교체
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks" # DynamoDB 테이블 이
    encrypt        = true
  }
}
