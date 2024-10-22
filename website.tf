#------------------------------------------------------------------------------
# CloudFront Origin Access Identity
#------------------------------------------------------------------------------
resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  provider = aws.main

  comment = "OAI to restrict access to AWS S3 content"
}

#------------------------------------------------------------------------------
# Website S3 Bucket
#------------------------------------------------------------------------------
#tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-encryption-customer-key tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "website" {
  # tfsec:ignore:AWS017
  provider = aws.main

  bucket        = local.website_bucket_name
  force_destroy = var.website_bucket_force_destroy

  # TODO - Add Lifecyle rule parameters
  # lifecycle_rule - (Optional) A configuration of object lifecycle management.

  # TODO - Add replication configuration parameters
  # replication_configuration - (Optional) A configuration of replication configuration.

  # TODO - Add variables for S3 object locking
  # object_lock_configuration - (Optional) A configuration of S3 object locking

  tags = merge({
    Name = "${var.name_prefix}-website"
  }, var.tags)
}

resource "aws_s3_bucket_versioning" "website" {
  provider = aws.main

  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status     = var.website_versioning_status
    mfa_delete = var.website_versioning_mfa_delete
  }
}

resource "aws_s3_bucket_cors_configuration" "website" {
  provider = aws.main

  bucket = aws_s3_bucket.website.id

  cors_rule {
    allowed_headers = var.website_cors_allowed_headers
    allowed_methods = var.website_cors_allowed_methods
    allowed_origins = concat(
      ((var.cloudfront_viewer_protocol_policy == "allow-all") ?
        ["http://${var.website_domain_name}", "https://${var.website_domain_name}"] :
      ["https://${var.website_domain_name}"]),
    var.website_cors_additional_allowed_origins)
    expose_headers  = var.website_cors_expose_headers
    max_age_seconds = var.website_cors_max_age_seconds
  }
}

resource "aws_s3_bucket_logging" "website" {
  provider = aws.main

  bucket        = aws_s3_bucket.website.id
  target_bucket = module.s3_logs_bucket.s3_bucket_id
  target_prefix = "website/"
}

resource "aws_s3_bucket_ownership_controls" "website" {
  provider = aws.main

  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "website" {
  depends_on = [aws_s3_bucket_ownership_controls.website]
  provider   = aws.main

  bucket = aws_s3_bucket.website.id
  acl    = var.website_bucket_acl
}

resource "aws_s3_bucket_policy" "website" {
  provider = aws.main

  bucket = aws_s3_bucket.website.id
  policy = templatefile("${path.module}/templates/s3_website_bucket_policy.json", {
    bucket_name = local.website_bucket_name
    cf_oai_arn  = aws_cloudfront_origin_access_identity.cf_oai.iam_arn
  })
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access_block" {
  provider = aws.main

  bucket                  = aws_s3_bucket.website.id
  ignore_public_acls      = true
  block_public_acls       = true
  restrict_public_buckets = true
  block_public_policy     = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website_bucket_website_server_side_encryption_configuration" {
  provider = aws.main
  count    = length(keys(var.website_server_side_encryption_configuration)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.website.id

  dynamic "rule" {
    for_each = try(flatten([var.website_server_side_encryption_configuration["rule"]]), [])

    content {
      bucket_key_enabled = try(rule.value.bucket_key_enabled, null)

      dynamic "apply_server_side_encryption_by_default" {
        for_each = try([rule.value.apply_server_side_encryption_by_default], [])

        content {
          sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
          kms_master_key_id = try(apply_server_side_encryption_by_default.value.kms_master_key_id, null)
        }
      }
    }
  }
}

#------------------------------------------------------------------------------
# Cloudfront for S3 Bucket Website
#------------------------------------------------------------------------------
# tfsec issues ignored
#  - AWS045: Enable WAF for the CloudFront distribution. Pending to implement.
resource "aws_cloudfront_distribution" "website" {
  # tfsec:ignore:AWS045
  provider = aws.main

  aliases = var.www_website_redirect_enabled ? [
    local.website_bucket_name,
    local.www_website_bucket_name
  ] : [local.website_bucket_name]

  web_acl_id = var.cloudfront_web_acl_id

  comment = var.comment_for_cloudfront_website

  # TODO - Add variable for Custom Error Responses
  # custom_error_response (Optional) - One or more custom error response elements (multiples allowed).

  # TODO - Add variables for cache and origin request policies.
  default_cache_behavior {
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Managed-CORS-S3Origin
    allowed_methods          = var.cloudfront_allowed_cached_methods
    cached_methods           = var.cloudfront_allowed_cached_methods
    target_origin_id         = local.website_bucket_name
    viewer_protocol_policy   = var.cloudfront_viewer_protocol_policy
    compress                 = var.cloudfront_enable_compression

    dynamic "function_association" {
      for_each = var.cloudfront_function_association
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
    dynamic "lambda_function_association" {
      for_each = var.cloudfront_lambda_function_association
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.cloudfront_custom_error_responses
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  default_root_object = var.cloudfront_default_root_object
  enabled             = true
  is_ipv6_enabled     = var.is_ipv6_enabled
  http_version        = var.cloudfront_http_version

  logging_config {
    include_cookies = false
    bucket          = module.s3_logs_bucket.s3_bucket_domain_name
    prefix          = "cloudfront_website"
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.cloudfront_ordered_cache_behaviors
    content {
      allowed_methods            = tolist(ordered_cache_behavior.value.allowed_methods)
      cached_methods             = tolist(ordered_cache_behavior.value.cached_methods)
      cache_policy_id            = ordered_cache_behavior.value.cache_policy_id
      compress                   = ordered_cache_behavior.value.compress
      default_ttl                = ordered_cache_behavior.value.default_ttl
      field_level_encryption_id  = ordered_cache_behavior.value.field_level_encryption_id
      max_ttl                    = ordered_cache_behavior.value.max_ttl
      min_ttl                    = ordered_cache_behavior.value.min_ttl
      origin_request_policy_id   = ordered_cache_behavior.value.origin_request_policy_id
      path_pattern               = ordered_cache_behavior.value.path_pattern
      realtime_log_config_arn    = ordered_cache_behavior.value.realtime_log_config_arn
      response_headers_policy_id = ordered_cache_behavior.value.response_headers_policy_id
      smooth_streaming           = ordered_cache_behavior.value.smooth_streaming
      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy     = ordered_cache_behavior.value.viewer_protocol_policy
    }
  }

  # TODO support origin groups
  # origin_group (Optional) - One or more origin_group for this distribution (multiples allowed).

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = local.website_bucket_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_oai.cloudfront_access_identity_path
    }
  }

  dynamic "origin" {
    for_each = var.cloudfront_additional_origins
    content {
      domain_name = origin.value.domain_name

      dynamic "custom_header" {
        for_each = origin.value.custom_header == null ? [] : [
          for h in origin.value.custom_header : {
            name  = h.name
            value = h.value
          }
        ]
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      origin_id                = origin.value.origin_id
      connection_attempts      = origin.value.connection_attempts
      connection_timeout       = origin.value.connection_timeout
      origin_access_control_id = origin.value.origin_access_control_id
      origin_path              = origin.value.origin_path

      dynamic "s3_origin_config" {
        for_each = origin.value.s3_origin_config[*]
        content {
          origin_access_identity = s3_origin_config.value.origin_access_identity
        }
      }

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config[*]
        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = custom_origin_config.value.origin_read_timeout
        }
      }
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

  viewer_certificate {
    acm_certificate_arn            = var.create_acm_certificate ? aws_acm_certificate_validation.cert_validation[0].certificate_arn : var.acm_certificate_arn_to_use
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
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
  provider = aws.main

  count = var.create_route53_website_records ? 1 : 0

  zone_id = var.create_route53_hosted_zone ? aws_route53_zone.hosted_zone[0].zone_id : var.route53_hosted_zone_id
  name    = local.website_bucket_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_cloudfront_record_ipv6" {
  provider = aws.main

  count = (var.is_ipv6_enabled && var.create_route53_website_records) ? 1 : 0

  zone_id = var.create_route53_hosted_zone ? aws_route53_zone.hosted_zone[0].zone_id : var.route53_hosted_zone_id
  name    = local.website_bucket_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_website_record" {
  provider = aws.main

  count = (var.www_website_redirect_enabled && var.create_route53_website_records) ? 1 : 0

  zone_id = var.create_route53_hosted_zone ? aws_route53_zone.hosted_zone[0].zone_id : var.route53_hosted_zone_id
  name    = local.www_website_bucket_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_website_record_ipv6" {
  provider = aws.main

  count = (var.is_ipv6_enabled && var.www_website_redirect_enabled && var.create_route53_website_records) ? 1 : 0

  zone_id = var.create_route53_hosted_zone ? aws_route53_zone.hosted_zone[0].zone_id : var.route53_hosted_zone_id
  name    = local.www_website_bucket_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
