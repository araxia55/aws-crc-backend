resource "aws_s3_bucket" "aws_crc" {
  bucket = "my-aws-crc-5555"
}

resource "aws_s3_bucket_ownership_controls" "aws_crc" {
  bucket = aws_s3_bucket.aws_crc.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "aws_crc" {
  depends_on = [aws_s3_bucket_ownership_controls.aws_crc]

  bucket = aws_s3_bucket.aws_crc.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "aws_crc_website" {
  bucket = aws_s3_bucket.aws_crc.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_public_access_block" "aws_crc" {
  bucket = aws_s3_bucket.aws_crc.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "aws_crc" {
  bucket = aws_s3_bucket.aws_crc.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.aws_crc.arn}/*"
      }
    ]
  })
}