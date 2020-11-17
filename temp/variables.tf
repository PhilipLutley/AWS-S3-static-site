variable "region" {
  description = "The region to deploy to."
  default     = "eu-west-2"
}

variable "domainName" {
  description = "The root domain name. E.g. example.com"
  type        = string
}

variable "sans" {
  description = "Subject alternate name addresses to include. E.g. www.example.com"
  type        = string
}