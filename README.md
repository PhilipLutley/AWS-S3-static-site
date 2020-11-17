# AWS-S3-static-site

This project is to create all the components of a secure static site on AWS S3 with cached by Cloudfront.

Brief summary of what is handled:

**s3.tf**
* S3 bucket with hosting enabled
* S3 bucket policy
* a default index.html file displaying "Hello, World!"
* S3 logging bucket

**route53.tf**
* Prerequisite - Your domain registrar is AWS & in the same account you're deploying to
* Route53 zone creation
* root and www records (e.g. example.com, www.example.com) set to point to cloudfront distribution
* Import nameserver info into state
* Update nameservers info in domain registrar (route53) record
* Create records for the cert validation process with ACM

**cloudfront.tf**
* caches the s3 bucket content
* serves up the SSL created by ACM
* Redirects http to https

**acm.tf**
* Creates ACM certificate in us-east-1 (in order to use with cloudfront)
* note acm.tf uses an aws provider alias to handle the us-east-1 stuff

# Prerequisites
* AWS is your domain registrar

# Example Usage
```hcl
module "site" {
source = "git@github.com:PhilipLutley/AWS-S3-static-site.git"
domainName = "example.com"
sans = "www.example.com"
}