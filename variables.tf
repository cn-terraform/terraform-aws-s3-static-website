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
# Log Bucket
#------------------------------------------------------------------------------
variable "log_bucket_versioning_status" {
  description = "(Optional) The versioning state of the bucket. Valid values: Enabled or Suspended. Defaults to Enabled"
  type        = string
  default     = "Enabled"
}

variable "log_bucket_versioning_mfa_delete" {
  description = "(Optional) Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled. Defaults to Disabled"
  type        = string
  default     = "Disabled"
}

variable "log_bucket_force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the log bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "aws_accounts_with_read_view_log_bucket" {
  description = "List of AWS accounts with read permissions to log bucket"
  type        = list(string)
  default     = []
}

#------------------------------------------------------------------------------
# Website
#------------------------------------------------------------------------------
variable "website_domain_name" {
  description = "The domain name to use for the website"
  type        = string
}

variable "website_bucket_acl" {
  description = "(Optional) The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write. Defaults to private."
  type        = string
  default     = "private"
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

variable "website_versioning_status" {
  description = "(Optional) The versioning state of the bucket. Valid values: Enabled or Suspended. Defaults to Enabled"
  type        = string
  default     = "Enabled"
}

variable "website_versioning_mfa_delete" {
  description = "(Optional) Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled. Defaults to Disabled"
  type        = string
  default     = "Disabled"
}

variable "website_server_side_encryption_configuration" {
  description = "(Optional) Map containing server-side encryption configuration for the website bucket. Defaults to no encryption. See examples/complete/main.tf for configuration example."
  type        = any
  default     = {}
}

#------------------------------------------------------------------------------
# WWW Website for redirection to Website
#------------------------------------------------------------------------------
variable "www_website_redirect_enabled" {
  description = "(Optional) Whether to redirect www subdomain. Defaults to true."
  type        = bool
  default     = true
}

variable "www_website_bucket_acl" {
  description = "(Optional) The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write. Defaults to private."
  type        = string
  default     = "private"
}

variable "www_website_bucket_force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "www_website_versioning_enabled" {
  description = "(Optional) Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. Defaults to true"
  type        = bool
  default     = true
}

variable "www_website_versioning_mfa_delete" {
  description = "(Optional) Enable MFA delete for either change the versioning state of your bucket or permanently delete an object version. Default is false. This cannot be used to toggle this setting but is available to allow managed buckets to reflect the state in AWS."
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# Cloudfront
#------------------------------------------------------------------------------
variable "comment_for_cloudfront_website" {
  description = "Comment for the Website CloudFront Distribution"
  type        = string
  default     = ""
}

variable "cloudfront_viewer_protocol_policy" {
  description = "Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https. Defautls to redirect-to-https"
  type        = string
  default     = "redirect-to-https"
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

variable "cloudfront_enable_compression" {
  description = "(Optional, Default:false) Enable compression with Gzip or Brotli for requests with a valid Accept-Encoding header"
  type        = bool
  default     = false
}

variable "cloudfront_function_association" {
  description = "(Optional - up to 2 per distribution) List containing information to associate a CF function to cloudfront. The first field is `event_type` of the CF function associated with default cache behavior, it can be viewer-request or viewer-response"
  type = list(object({
    event_type   = string
    function_arn = string
  }))
  default = []
}

variable "cloudfront_custom_error_responses" {
  description = "A list of custom error responses"
  type = list(object({
    error_caching_min_ttl = number
    error_code            = number
    response_code         = number
    response_page_path    = string
  }))
  default = []
}

variable "cloudfront_ordered_cache_behaviors" {
  description = "A list of custom ordered cache behaviors"
  type = list(object({
    allowed_methods           = list(string)
    cached_methods            = list(string)
    cache_policy_id           = string
    compress                  = optional(bool)
    default_ttl               = optional(number)
    field_level_encryption_id = optional(string)
    # forwarded_values will not be supported as Hashicorp had already deprecated it at the time of implementing this module
    # TODO support lambda_function_association and function_association
    max_ttl                    = optional(number)
    min_ttl                    = optional(number)
    origin_request_policy_id   = string
    path_pattern               = optional(string)
    realtime_log_config_arn    = optional(string)
    response_headers_policy_id = optional(string)
    smooth_streaming           = optional(bool)
    target_origin_id           = string
    # TODO support trusted_key_groups and trusted_signers
    viewer_protocol_policy = string
  }))
  default = []
}

variable "cloudfront_additional_origins" {
  description = "(Optional) A list of additional origins besides the web site"
  type = list(object({
    connection_attempts = optional(number)
    connection_timeout  = optional(number)
    custom_origin_config = optional(object({
      http_port                = number
      https_port               = number
      origin_protocol_policy   = string
      origin_ssl_protocols     = list(string)
      origin_keepalive_timeout = optional(number)
      origin_read_timeout      = optional(number)
    }))
    domain_name = string
    custom_header : optional(list(
      object({
        name  = string
        value = string
      }))
    )
    origin_access_control_id = optional(string)
    origin_id                = string
    origin_path              = optional(string)
    # TODO support origin_shield
    s3_origin_config = optional(object({
      origin_access_identity = string
    }))
  }))
  default = []
}

variable "cloudfront_web_acl_id" {
  description = "(Optional) A unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution."
  type        = string
  default     = null
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

variable "cloudfront_website_wait_for_deployment" {
  description = "(Optional) - If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. Defaults to true."
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# Route53
#------------------------------------------------------------------------------
variable "create_route53_hosted_zone" {
  description = "Enable or disable Route 53 hosted zone creation. If set to false, the variable route53_hosted_zone_id is required. Defaults to true"
  type        = bool
  default     = true
}

variable "route53_hosted_zone_id" {
  description = "The Route 53 hosted zone ID to use if create_route53_hosted_zone is false"
  type        = string
  default     = ""
}

variable "create_route53_website_records" {
  description = "Enable or disable creation of Route 53 records in the hosted zone. Defaults to true"
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# ACM Certificate
#------------------------------------------------------------------------------
variable "create_acm_certificate" {
  description = "Enable or disable automatic ACM certificate creation. If set to false, the variable acm_certificate_arn_to_use is required. Defaults to true"
  type        = bool
  default     = true
}

variable "acm_certificate_arn_to_use" {
  description = "ACM Certificate ARN to use in case you disable automatic certificate creation. Certificate must be in us-east-1 region."
  type        = string
  default     = ""
}
