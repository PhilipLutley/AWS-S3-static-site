variable "domainName" {
  default = "philsdev.com"
}

variable "sans" {
  description = "SAN addresses to include. E.g. www"
  default     = "www.philsdev.com"
}