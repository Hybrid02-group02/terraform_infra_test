variable "aws_region" {
  default = "ap-northeast-2"
}

variable "backend_bucket_name" {
  default = "my-terraform-backend-bucket-20250402"
}

variable "dynamodb_table_name" {
  default = "terraform-locks"
}


