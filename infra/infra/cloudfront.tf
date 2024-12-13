resource "aws_acm_certificate" "MyCertificate" {
  domain_name       = "www.raymund.cloud"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "MyCertificateValidation" {
  certificate_arn = aws_acm_certificate.MyCertificate.arn
}

data "aws_cloudfront_cache_policy" "cachingDisabled" {
  name = "Managed-CachingDisabled"
}

locals {
  s3_origin_id = "my-aws-crc-5555.s3-website-us-east-1.amazonaws.com"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.aws_crc.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    custom_origin_config {
      origin_protocol_policy = "match-viewer"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CF distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.s3_origin_id
    cache_policy_id          = data.aws_cloudfront_cache_policy.cachingDisabled.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

 restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.MyCertificate.arn
    ssl_support_method  = "sni-only"
  }
    # cloudfront as an alias
    aliases = ["www.raymund.cloud"]
}
