resource "aws_s3_bucket" "ecommerce_website_bucket" {
  bucket = var.domain_name
  acl    = "public-read"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = ["arn:aws:s3:::${var.domain_name}/*"]
      }
    ]
  })

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.logs_bucket.id
    target_prefix = "s3-access/${var.domain_name}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource aws_s3_bucket "logs_bucket" {
  bucket = "${var.domain_name}-access-logs-${data.aws_caller_identity.current.account_id}"
  acl = "log-delivery-write"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}