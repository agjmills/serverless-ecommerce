resource aws_cloudfront_distribution "ecommerce_frontend_cdn" {
  origin {
    domain_name = aws_s3_bucket.ecommerce_website_bucket.bucket_regional_domain_name
    origin_id = "www.${var.domain_name}"
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  aliases = [var.domain_name, "www.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "www.${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = module.frontend_certificate.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = ["GB"]
    }
  }
}