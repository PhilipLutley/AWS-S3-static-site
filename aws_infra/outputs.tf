output "nameservers" {
  value = aws_route53_record.philsdevns.records
}