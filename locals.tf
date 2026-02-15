locals {
  website_bucket_name     = var.website_settings.domain_name
  www_website_bucket_name = format("www.%s", var.website_settings.domain_name)
}
