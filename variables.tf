#------------------------------------------------------------------------------
# Misc
#------------------------------------------------------------------------------
variable "name_prefix" {
  description = "Name prefix for resources on AWS"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

#------------------------------------------------------------------------------
# Website
#------------------------------------------------------------------------------
variable "website_domain_name" {
  description = "The domain name to use for the website"
  type        = string
}

variable "website_bucket_force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "website_index_document" {
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders.  Defaults to index.html"
  type        = string
  default     = "index.html"
}

variable "website_error_document" {
  description = "(Optional) An absolute path to the document to return in case of a 4XX error. Defaults to 404.html"
  type        = string
  default     = "404.html"
}

variable "website_cors_allowed_headers" {
  description = "(Optional) Specifies which headers are allowed. Defaults to Authorization and Content-Length"
  type        = list(string)
  default     = ["Authorization", "Content-Length"]
}

variable "website_cors_allowed_methods" {
  description = "(Optional) Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. Defaults to GET and POST"
  type        = list(string)
  default     = ["GET", "POST"]
}

variable "website_cors_additional_allowed_origins" {
  description = "(Optional) Specifies which origins are allowed besides the domain name specified"
  type        = list(string)
  default     = []
}

variable "website_cors_expose_headers" {
  description = "(Optional) Specifies expose header in the response."
  type        = list(string)
  default     = []
}

variable "website_cors_max_age_seconds" {
  description = "(Optional) Specifies time in seconds that browser can cache the response for a preflight request. Defaults to 3600"
  type        = number
  default     = 3600
}

variable "website_versioning_enabled" {
  description = "(Optional) Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. Defaults to false"
  type        = bool
  default     = false
}

variable "website_versioning_mfa_delete" {
  description = "(Optional) Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version. Default is false. This cannot be used to toggle this setting but is available to allow managed buckets to reflect the state in AWS."
  type        = bool
  default     = false
}

variable "website_acceleration_status" {
  description = "(Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = "Suspended"
}

#------------------------------------------------------------------------------
# WWW Website for redirection to Website
#------------------------------------------------------------------------------
variable "www_website_bucket_force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# Cloudfront
#------------------------------------------------------------------------------
variable "enable_cloudfront" {
  description = "Indicates if Cloudfront should be created or not"
  type        = bool
  default     = true
}

variable "comment_for_cloudfront_website" {
  description = "Comment for the Website CloudFront Distribution"
  type        = string
  default     = ""
}

variable "comment_for_cloudfront_www_website" {
  description = "Comment for the WWW Website CloudFront Distribution"
  type        = string
  default     = ""
}

variable "is_ipv6_enabled" {
  description = "(Optional) - Whether the IPv6 is enabled for the distribution. Defaults to true"
  type        = bool
  default     = true
}

variable "cloudfront_allowed_cached_methods" {
  description = "(Optional) Specifies which methods are allowed and cached by CloudFront. Can be GET, PUT, POST, DELETE or HEAD. Defaults to GET and HEAD"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cloudfront_default_root_object" {
  description = "(Optional) - The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. Defaults to index.html"
  type        = string
  default     = "index.html"
}

variable "cloudfront_http_version" {
  description = "(Optional) - The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2."
  type        = string
  default     = "http2"
}

variable "cloudfront_origin_http_port" {
  description = "The HTTP port the custom origin listens on. Defaults to 80"
  type        = number
  default     = 80
}

variable "cloudfront_origin_https_port" {
  description = "The HTTPS port the custom origin listens on. Defaults to 443"
  type        = number
  default     = 443
}

variable "cloudfront_origin_protocol_policy" {
  description = "The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer."
  type        = string
  default     = "match-viewer"
}

variable "cloudfront_origin_ssl_protocols" {
  description = "The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. A list of one or more of SSLv3, TLSv1, TLSv1.1, and TLSv1.2. Defaults to TLSv1, TLSv1.1 and TLSv1.2"
  type        = list(string)
  default     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
}

variable "cloudfront_price_class" {
  description = "(Optional) - The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100. Defaults to PriceClass_100"
  type        = string
  default     = "PriceClass_100"
}

variable "cloudfront_geo_restriction_type" {
  description = "The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist. Defaults to none"
  type        = string
  default     = "none"
}

variable "cloudfront_geo_restriction_locations" {
  description = "(Optional) - The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist). Defaults to []"
  type        = list(string)
  default     = []
}

variable "cloudfront_website_retain_on_delete" {
  description = "(Optional) - Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. Defaults to false."
  type        = bool
  default     = false
}

variable "cloudfront_www_website_retain_on_delete" {
  description = "(Optional) - Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. Defaults to false."
  type        = bool
  default     = false
}

variable "cloudfront_website_wait_for_deployment" {
  description = "(Optional) - If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. Defaults to true."
  type        = bool
  default     = true
}

variable "cloudfront_www_website_wait_for_deployment" {
  description = "(Optional) - If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. Defaults to true."
  type        = bool
  default     = true
}
