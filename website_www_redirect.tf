#------------------------------------------------------------------------------
# S3 Bucket for redirection from URL with www to the one without www
#------------------------------------------------------------------------------
data "template_file" "www_website_bucket_policy" {
  template = file("${path.module}/templates/s3_website_bucket_policy.json")
  vars = {
    bucket_name = local.www_website_bucket_name
  }
}

# tfsec issues ignored (https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html)
#  - AWS001: The contents of the bucket can be accessed publicly. Access should be allowed because it is hosting a website
#  - AWS017: The bucket objects could be read if compromised. TODO, implement this.
resource "aws_s3_bucket" "www_website" { # tfsec:ignore:AWS017
  provider = aws.main

  bucket        = local.www_website_bucket_name
  acl           = var.www_website_bucket_acl
  policy        = data.template_file.www_website_bucket_policy.rendered # tfsec:ignore:AWS001
  force_destroy = var.www_website_bucket_force_destroy

  website {
    redirect_all_requests_to = var.website_domain_name
  }

  versioning {
    enabled    = var.website_versioning_enabled
    mfa_delete = var.website_versioning_mfa_delete
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "www-website/"
  }

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "aws:kms"
  #     }
  #   }
  # }

  tags = merge({
    Name = "${var.name_prefix}-www-website"
  }, var.tags)
}

# tfsec issues ignored (https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html)
#  - AWS073: PUT calls with public ACLs specified can make objects public. Should be disabled for bucket hosting a website
#  - AWS074: PUT calls with public ACLs specified can make objects public. Should be disabled for bucket hosting a website
#  - AWS075: Public buckets can be accessed by anyone. Should be disabled for bucket hosting a website
#  - AWS076: Users could put a policy that allows public access. Should be disabled for bucket hosting a website
resource "aws_s3_bucket_public_access_block" "www_website_bucket_public_access_block" {
  provider = aws.main

  bucket                  = aws_s3_bucket.www_website.id
  ignore_public_acls      = false # tfsec:ignore:AWS073
  block_public_acls       = false # tfsec:ignore:AWS074
  restrict_public_buckets = false # tfsec:ignore:AWS075
  block_public_policy     = false # tfsec:ignore:AWS076
}

#------------------------------------------------------------------------------
# Cloudfront for S3 Bucket for WWW Website Redirection
#------------------------------------------------------------------------------
# tfsec issues ignored
#  - AWS045: Enable WAF for the CloudFront distribution. Pending to implement.
resource "aws_cloudfront_distribution" "www_website" { # tfsec:ignore:AWS045
  provider = aws.main

  count = var.enable_cloudfront ? 1 : 0

  aliases = [local.www_website_bucket_name]
  comment = var.comment_for_cloudfront_www_website

  # TODO - Add variable for Custom Error Responses
  # custom_error_response (Optional) - One or more custom error response elements (multiples allowed).

  # TODO - Add variables for cache and origin request policies.
  default_cache_behavior {
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Managed-CORS-S3Origin
    allowed_methods          = var.cloudfront_allowed_cached_methods
    cached_methods           = var.cloudfront_allowed_cached_methods
    target_origin_id         = "S3-${local.www_website_bucket_name}"
    viewer_protocol_policy   = var.cloudfront_viewer_protocol_policy
  }

  enabled         = true
  is_ipv6_enabled = var.is_ipv6_enabled
  http_version    = var.cloudfront_http_version

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.log_bucket.bucket_domain_name
    prefix          = "cloudfront_www_website"
  }

  # TODO - Add variable to support ordered_cache_behavior
  # ordered_cache_behavior (Optional) - An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0.

  origin {
    domain_name = aws_s3_bucket.www_website.website_endpoint
    origin_id   = "S3-${local.www_website_bucket_name}"
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-https-cloudfront-to-s3-origin.html
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
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
    Name = "${var.name_prefix}-www-website"
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

  retain_on_delete    = var.cloudfront_www_website_retain_on_delete
  wait_for_deployment = var.cloudfront_www_website_wait_for_deployment
}

#------------------------------------------------------------------------------
# Cloudfront DNS Record (if CloudFront is enabled)
#------------------------------------------------------------------------------
resource "aws_route53_record" "www_website_cloudfront_record" {
  provider = aws.main

  count = var.enable_cloudfront ? 1 : 0

  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = local.www_website_bucket_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www_website[0].domain_name
    zone_id                = aws_cloudfront_distribution.www_website[0].hosted_zone_id
    evaluate_target_health = false
  }
}

#------------------------------------------------------------------------------
# S3 DNS Record (if CloudFront is disabled)
#------------------------------------------------------------------------------
resource "aws_route53_record" "www_website_s3_record" {
  provider = aws.main

  count = var.enable_cloudfront ? 0 : 1

  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = local.www_website_bucket_name
  type    = "A"

  alias {
    name                   = aws_s3_bucket.www_website.website_domain
    zone_id                = aws_s3_bucket.www_website.hosted_zone_id
    evaluate_target_health = false
  }
}
