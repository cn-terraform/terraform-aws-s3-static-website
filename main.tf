#------------------------------------------------------------------------------
# Locals
#------------------------------------------------------------------------------
locals {
  website_bucket_name     = var.website_domain_name
  www_website_bucket_name = "www.${var.website_domain_name}"
}

#------------------------------------------------------------------------------
# S3 Bucket for logs
#------------------------------------------------------------------------------
#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "log_bucket" {
  provider = aws.main

  bucket = "${var.name_prefix}-log-bucket"

  versioning {
    enabled    = var.log_bucket_versioning_enabled
    mfa_delete = var.log_bucket_versioning_mfa_delete
  }

  tags = merge({
    Name = "${var.name_prefix}-logs"
  }, var.tags)
}

resource "aws_s3_bucket_acl" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_public_access_block" "log_bucket_public_access_block" {
  provider = aws.main

  bucket                  = aws_s3_bucket.log_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "log_bucket_access_policy" {
  provider = aws.main

  statement {
    sid = "Allow access to logs bucket to current account"

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      aws_s3_bucket.log_bucket.arn,
      "${aws_s3_bucket.log_bucket.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.aws_accounts_with_read_view_log_bucket)
    }
  }
}

resource "aws_s3_bucket_policy" "log_bucket_access_policy" {
  provider = aws.main

  # Dependency to avoid writing bucket policy and public access block at the same time
  depends_on = [
    aws_s3_bucket_public_access_block.log_bucket_public_access_block,
  ]

  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.log_bucket_access_policy.json
}

#------------------------------------------------------------------------------
# Route53 Hosted Zone
#------------------------------------------------------------------------------
resource "aws_route53_zone" "hosted_zone" {
  provider = aws.main

  count = var.create_route53_hosted_zone ? 1 : 0

  name = var.website_domain_name
  tags = merge({
    Name = "${var.name_prefix}-hosted-zone"
  }, var.tags)
}

#------------------------------------------------------------------------------
# ACM Certificate
#------------------------------------------------------------------------------
resource "aws_acm_certificate" "cert" {
  provider = aws.acm_provider

  count = var.create_acm_certificate ? 1 : 0

  domain_name               = "*.${var.website_domain_name}"
  subject_alternative_names = [var.website_domain_name]

  validation_method = "DNS"

  tags = merge({
    Name = var.website_domain_name
  }, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_certificate_validation_records" {
  provider = aws.main

  for_each = {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } if var.create_acm_certificate
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = var.create_route53_hosted_zone ? aws_route53_zone.hosted_zone[0].zone_id : var.route53_hosted_zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.acm_provider

  # Dependency to guarantee that certificate and DNS records are created before this resource
  depends_on = [
    aws_acm_certificate.cert,
    aws_route53_record.acm_certificate_validation_records,
  ]

  count = var.create_acm_certificate ? 1 : 0

  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.acm_certificate_validation_records : record.fqdn]
}
