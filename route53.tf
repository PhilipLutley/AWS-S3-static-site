resource "aws_route53_zone" "sitedns" {
  name = var.domainName

  tags = {
    owner = var.domainName
  }
}

resource "aws_route53_record" "root" {
  name    = var.domainName
  type    = "A"
  zone_id = aws_route53_zone.sitedns.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
  }
}

resource "aws_route53_record" "www" {
  name    = var.sans
  type    = "A"
  zone_id = aws_route53_zone.sitedns.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
  }
}

//Route53 assigns random nameserver records so we "import" them then update the registered domain NS to be in sync.
//This is needed for ACM certificate validation. If there is a difference then the cert validation will sit in pending forever.
resource "aws_route53_record" "nameservers" {
  allow_overwrite = true
  name            = var.domainName
  type            = "NS"
  zone_id         = aws_route53_zone.sitedns.zone_id
  ttl             = "60"

  records = [
    aws_route53_zone.sitedns.name_servers[0],
    aws_route53_zone.sitedns.name_servers[1],
    aws_route53_zone.sitedns.name_servers[2],
    aws_route53_zone.sitedns.name_servers[3],
  ]
}

//This will execute immediately during the apply phase but Route53 takes a few mins to catch up. In the console you can check your change
//is being processed under Route53->Domains->Pending requests
//also worth noting a destroy will not update/remove the entry in the registered domain
resource "null_resource" "updatens-domain" {
  depends_on = [aws_route53_record.nameservers]
  provisioner "local-exec" {
    command = "aws route53domains update-domain-nameservers --region us-east-1 --domain-name ${var.domainName} --nameservers Name=${aws_route53_zone.sitedns.name_servers.0} Name=${aws_route53_zone.sitedns.name_servers.1} Name=${aws_route53_zone.sitedns.name_servers.2} Name=${aws_route53_zone.sitedns.name_servers.3}"

  }
}

resource "aws_route53_record" "cert_verify" {
  for_each = {
    for dvo in aws_acm_certificate.site_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.sitedns.zone_id
}