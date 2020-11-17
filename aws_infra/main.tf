provider "aws" {
  region  = var.region
  version = "~> 3.0"
}

provider "aws" {
  //required for creating the ACM cert in us-east-1 so can use with CloudFront
  alias  = "us-east-1"
  region = "us-east-1"
}

terraform {
  required_version = "~> 0.13"
}