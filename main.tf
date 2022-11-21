#------------------------------------------------------------------------------
# Locals
#------------------------------------------------------------------------------
locals {
  website_bucket_name     = var.website_domain_name
  www_website_bucket_name = "www.${var.website_domain_name}"
}

#------------------------------------------------------------------------------
# S3 BUCKET - For access logs
#------------------------------------------------------------------------------
#tfsec:ignore:aws-s3-enable-versioning
module "s3_logs_bucket" {
  providers = {
    aws = aws.main
  }

  source  = "cn-terraform/logs-s3-bucket/aws"
  version = "1.0.5"
  # source  = "../terraform-aws-logs-s3-bucket"

  name_prefix                   = "${var.name_prefix}-log-bucket"
  aws_principals_identifiers    = formatlist("arn:aws:iam::%s:root", var.aws_accounts_with_read_view_log_bucket)
  block_s3_bucket_public_access = true
  s3_bucket_force_destroy       = var.log_bucket_force_destroy
  # enable_s3_bucket_server_side_encryption        = var.enable_s3_bucket_server_side_encryption
  # s3_bucket_server_side_encryption_sse_algorithm = var.s3_bucket_server_side_encryption_sse_algorithm
  # s3_bucket_server_side_encryption_key           = var.s3_bucket_server_side_encryption_key

  tags = merge({
    Name = "${var.name_prefix}-logs"
  }, var.tags)
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

  for_each = var.create_acm_certificate ? {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

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
