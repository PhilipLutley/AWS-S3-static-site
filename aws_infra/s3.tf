resource "aws_s3_bucket" "philsdev" {
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

  tags = merge(
    var.defaultTags,
    {
      owner = var.domainName
    },
  )
}

resource "aws_s3_bucket_object" "indexpage" {
  bucket       = aws_s3_bucket.philsdev.id
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "errorpage" {
  bucket       = aws_s3_bucket.philsdev.id
  key          = "404.html"
  source       = "./404.html"
  content_type = "text/html"
}