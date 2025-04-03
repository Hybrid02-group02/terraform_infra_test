output "s3_state_bucket_name" {
  description = "The name of the S3 bucket used for Terraform backend"
  value       = aws_s3_bucket.tf_backend.id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.tf_lock.name
}
