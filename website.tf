#------------------------------------------------------------------------------
# Website S3 Bucket
#------------------------------------------------------------------------------
data "template_file" "website_bucket_policy" {
  template = file("${path.module}/templates/s3_website_bucket_policy.json")
  vars = {
    bucket_name = local.website_bucket_name
  }
}

resource "aws_s3_bucket" "website" {
  bucket        = local.website_bucket_name
  acl           = "public-read"
  policy        = data.template_file.website_bucket_policy.rendered
  force_destroy = var.website_bucket_force_destroy

  website {
    index_document = var.website_index_document
    error_document = var.website_error_document
  }

  cors_rule {
    allowed_headers = var.website_cors_allowed_headers
    allowed_methods = var.website_cors_allowed_methods
    allowed_origins = concat(["http://${var.website_domain_name}", "https://${var.website_domain_name}"], var.website_cors_additional_allowed_origins)
    expose_headers  = var.website_cors_expose_headers
    max_age_seconds = var.website_cors_max_age_seconds
  }

  versioning {
    enabled    = var.website_versioning_enabled
    mfa_delete = var.website_versioning_mfa_delete
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "website/"
  }

  # TODO - Add Lifecyle rule parameters
  # lifecycle_rule - (Optional) A configuration of object lifecycle management.

  acceleration_status = var.website_acceleration_status

  # TODO - Add replication configuration parameters
  # replication_configuration - (Optional) A configuration of replication configuration.

  # TODO - Add server side encryption
  # server_side_encryption_configuration - (Optional) A configuration of server-side encryption configuration

  # TODO - Add variables for S3 object locking
  # object_lock_configuration - (Optional) A configuration of S3 object locking

  tags = merge({
    Name = "${var.name_prefix}-website"
  }, var.tags)
}

#------------------------------------------------------------------------------
# Cloudfront for S3 Bucket Website
#------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "website" {
  count = var.enable_cloudfront ? 1 : 0

  aliases = [local.website_bucket_name]
  comment = var.comment_for_cloudfront_website

  # TODO - Add variable for Custom Error Responses
  # custom_error_response (Optional) - One or more custom error response elements (multiples allowed).

  default_cache_behavior {
    allowed_methods        = var.cloudfront_allowed_cached_methods
    cached_methods         = var.cloudfront_allowed_cached_methods
    target_origin_id       = "S3-.${local.website_bucket_name}"
    viewer_protocol_policy = "allow-all" # Change to "redirect-to-https" when HTTPS supported

    # min_ttl                = 31536000
    # default_ttl            = 31536000
    # max_ttl                = 31536000
    # compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  default_root_object = var.cloudfront_default_root_object
  enabled             = true
  is_ipv6_enabled     = var.is_ipv6_enabled
  http_version        = var.cloudfront_http_version

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.log_bucket.id
    prefix          = "cloudfront_website"
  }

  # TODO - Add variable to support ordered_cache_behavior
  # ordered_cache_behavior (Optional) - An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0.

  origin {
    domain_name = aws_s3_bucket.website.website_endpoint
    origin_id   = "S3-.${local.website_bucket_name}"
    custom_origin_config {
      http_port              = var.cloudfront_origin_http_port
      https_port             = var.cloudfront_origin_https_port
      origin_protocol_policy = var.cloudfront_origin_protocol_policy
      origin_ssl_protocols   = var.cloudfront_origin_ssl_protocols
    }
  }

  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction_type
      locations        = var.cloudfront_geo_restriction_locations
    }
  }

  tags = merge({
    Name = "${var.name_prefix}-website"
  }, var.tags)

  # TODO - Work on SSL certificates
  # viewer_certificate (Required) - The SSL configuration for this distribution (maximum one).
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # TODO - Work to add Web ACL variables
  # web_acl_id (Optional) - A unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution.
  # To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws_wafv2_web_acl.example.arn. To specify a web ACL created using AWS WAF Classic, use the ACL ID, for example aws_waf_web_acl.example.id. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned.

  retain_on_delete    = var.cloudfront_website_retain_on_delete
  wait_for_deployment = var.cloudfront_website_wait_for_deployment
}

#------------------------------------------------------------------------------
# Cloudfront DNS Record (if CloudFront is enabled)
#------------------------------------------------------------------------------
resource "aws_route53_record" "website_cloudfront_record" {
  count = var.enable_cloudfront ? 1 : 0

  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = local.website_bucket_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website[0].domain_name
    zone_id                = aws_cloudfront_distribution.website[0].hosted_zone_id
    evaluate_target_health = false
  }
}

#------------------------------------------------------------------------------
# S3 DNS Record (if CloudFront is disabled)
#------------------------------------------------------------------------------
resource "aws_route53_record" "website_s3_record" {
  count = var.enable_cloudfront ? 0 : 1

  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = local.website_bucket_name
  type    = "A"

  alias {
    name                   = aws_s3_bucket.website.website_domain
    zone_id                = aws_s3_bucket.website.hosted_zone_id
    evaluate_target_health = false
  }
}
