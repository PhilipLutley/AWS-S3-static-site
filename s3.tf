resource "aws_s3_bucket" "site" {
  bucket = var.domainName
  acl    = "public-read"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PUBLICPOLICY",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.domainName}/*"
    }
  ]
}
POLICY

  versioning {
    enabled = false
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  logging {
    target_bucket = aws_s3_bucket.site-logs.bucket
    target_prefix = "${var.domainName}/logs"
  }

  tags = {
    owner = var.domainName
  }
}

resource "aws_s3_bucket" "site-logs" {
  bucket = "${var.domainName}-sitelogs"
  acl    = "log-delivery-write"
}