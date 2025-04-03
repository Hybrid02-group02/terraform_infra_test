variable "aws_region" {
  default = "ap-northeast-2"
}

variable "backend_bucket_name" {
  default = "project02-terraform-state-bucket"
}

variable "dynamodb_table_name" {
  default = "terraform-locks"
}


