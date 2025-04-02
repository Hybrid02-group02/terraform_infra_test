	resource "aws_s3_bucket" "main" { # s3 버킷 생성
  bucket = "${var.project_name}-${var.name}"

  tags = {
    Name        = "${var.project_name}-${var.name}"
    Environment = var.environment
  }

  force_destroy = var.force_destroy # 버킷에 객체가 있어도 삭제 가능하게 할지 여부
}

resource "aws_s3_bucket_versioning" "versioning" { # 버전 관리
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" { # s3 공개 접근 제어
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" { # 서버 측 암호화 (AES256 사용)
  count  = var.enable_sse ? 1 : 0
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
