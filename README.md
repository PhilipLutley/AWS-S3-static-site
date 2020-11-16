# AWS-S3-static-site

This project is to create all the components of a static site on AWS S3 cached by Cloudfront.

The following is handled:

s3.tf
* S3 bucket creation
* S3 bucket policy configured for public read
* a default index.html file displaying "Hello, World!"
* 404.html

route53.tf
* Prerequisite - Your domain registrar is AWS & in the same account you're deploying to
* Route53 zone creation
* root and www records (e.g. example.com, www.example.com) set to point to cloudfront distribution
* Import nameserver info into state
* Update nameservers info in domain registrar (route53) record
* Create records for the cert validation process with ACM

cloudfront.tf
* caches the aws s3 bucket content
* serves up the SSL created by ACM
* Redirects http to https

acm.tf
* Creates ACM certificate in us-east-1 (in order to use with cloudfront)
* note acm.tf uses an aws provider alias to handle the us-east-1 stuff
