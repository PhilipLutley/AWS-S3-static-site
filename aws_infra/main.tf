terraform {
  required_version = "~> 0.13"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 3.0"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}