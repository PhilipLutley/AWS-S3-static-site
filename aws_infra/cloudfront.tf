resource "aws_cloudfront_distribution" "site" {

  depends_on = [aws_acm_certificate_validation.certvalidation]

  origin {
    origin_id   = var.domainName
    domain_name = aws_s3_bucket.site.website_endpoint

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = [
      "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"

  aliases = [
    var.domainName,
    var.sans
  ]
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods = [
      "GET",
    "HEAD"]
    cached_methods = [
      "GET",
    "HEAD"]
    target_origin_id = aws_s3_bucket.site.id

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site_certificate.arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    owner = var.domainName
  }
}