resource "aws_s3_bucket" "main" {
  bucket = "bank-infra-backend"
  acl    = "private"

  tags = {
    Name        = "bank-infra-backend"
    Environment = "Dev"
  }
  lifecycle {
    prevent_destroy = "true"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

