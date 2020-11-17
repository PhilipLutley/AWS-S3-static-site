resource "aws_acm_certificate" "site_certificate" {
  provider                  = aws.us-east-1
  domain_name               = var.domainName
  subject_alternative_names = [var.sans]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    owner = var.domainName
  }
}

resource "aws_acm_certificate_validation" "certvalidation" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.site_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_verify : record.fqdn]
}