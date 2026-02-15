####################
# Access logs bucket
####################
module "s3_logs_bucket" {
  providers = {
    aws = aws.main
  }

  source  = "cn-terraform/logs-s3-bucket/aws"
  version = "2.0.0"
  # source  = "../terraform-aws-logs-s3-bucket"

  bucket_name         = format("%s-log-bucket", var.name_prefix)
  force_destroy       = false
  object_lock_enabled = false
  tags                = {}

  log_delivery_principals = [
    "logging.s3.amazonaws.com"
  ]

  bucket_server_side_encryption = {
    kms_master_key_id : null,
    sse_algorithm : "AES256"
  }

  bucket_versioning = {
    mfa_delete : "Enabled",
    status : "Enabled"
  }
}

#####################
# Route53 Hosted Zone
#####################
resource "aws_route53_zone" "hosted_zone" {
  provider = aws.main

  count = var.create_route53_hosted_zone ? 1 : 0

  name = var.website_settings.domain_name
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-hosted-zone"
    }
  )
}

#################
# ACM Certificate
#################
resource "aws_acm_certificate" "cert" {
  provider = aws.acm_provider

  count = var.create_acm_certificate ? 1 : 0

  domain_name               = "*.${var.website_settings.domain_name}"
  subject_alternative_names = [var.website_settings.domain_name]

  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      Name = var.website_settings.domain_name
    }
  )

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
