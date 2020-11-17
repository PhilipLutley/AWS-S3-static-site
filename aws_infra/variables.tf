variable "domainName" {
  description = "The root domain name. E.g. example.com"
  type        = string
}

variable "sans" {
  description = "Subject alternate name addresses to include. E.g. www.example.com"
}

variable "defaultTags" {
  type = map
}