#------------------------------------------------------------------------------
# S3 Bucket for redirection from URL with www to the one without www
#------------------------------------------------------------------------------
data "template_file" "www_website_bucket_policy" {
  template = file("${path.module}/templates/s3_website_bucket_policy.json")
  vars = {
    bucket_name = local.www_website_bucket_name
  }
}

resource "aws_s3_bucket" "www_website" {
  bucket        = local.www_website_bucket_name
  acl           = "public-read"
  policy        = data.template_file.www_website_bucket_policy.rendered
  force_destroy = var.www_website_bucket_force_destroy

  website {
    redirect_all_requests_to = var.website_domain_name
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "www-website/"
  }

  tags = merge({
    Name = "${var.name_prefix}-www-website"
  }, var.tags)
}

#------------------------------------------------------------------------------
# Cloudfront for S3 Bucket for WWW Website Redirection
#------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "www_website" {
  count = var.enable_cloudfront ? 1 : 0

  aliases = [local.www_website_bucket_name]
  comment = var.comment_for_cloudfront_www_website

  # TODO - Add variable for Custom Error Responses
  # custom_error_response (Optional) - One or more custom error response elements (multiples allowed).

  default_cache_behavior {
    allowed_methods        = var.cloudfront_allowed_cached_methods
    cached_methods         = var.cloudfront_allowed_cached_methods
    target_origin_id       = "S3-${local.www_website_bucket_name}"
    viewer_protocol_policy = "allow-all"

    # min_ttl                = 0
    # default_ttl            = 86400
    # max_ttl                = 31536000

    forwarded_values {
      query_string = true
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }
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
    Name = "${var.name_prefix}-www-website"
  }, var.tags)

  # TODO - Work on SSL certificates
  # viewer_certificate (Required) - The SSL configuration for this distribution (maximum one).
  viewer_certificate {
    cloudfront_default_certificate = true
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
