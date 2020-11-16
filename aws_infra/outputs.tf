output "nameservers" {
  value = aws_route53_record.philsdevns.records
}

output "cf_distribution_id" {
  value       = aws_cloudfront_distribution.site.id
  description = "CloudFront distribution ID"
}

output "cf_website_endpoint" {
  value       = aws_cloudfront_distribution.site.domain_name
  description = "CloudFront website endpoint"
}