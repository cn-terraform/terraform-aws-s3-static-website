#------------------------------------------------------------------------------
# Locals
#------------------------------------------------------------------------------
locals {
  website_bucket_name     = var.website_domain_name
  www_website_bucket_name = "www.${var.website_domain_name}"
}

#------------------------------------------------------------------------------
# KMS Key for S3 server side encryption
#------------------------------------------------------------------------------
resource "aws_kms_key" "s3_encryption_key" {
  description             = "KMS Key for S3 server side encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = merge({
    Name = "${var.name_prefix}-s3-enc-key"
  }, var.tags)
}

#------------------------------------------------------------------------------
# S3 Bucket for logs
#------------------------------------------------------------------------------
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.name_prefix}-log-bucket"
  acl    = "log-delivery-write"

  versioning {
    enabled    = var.log_bucket_versioning_enabled
    mfa_delete = var.log_bucket_versioning_mfa_delete
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = merge({
    Name = "${var.name_prefix}-logs"
  }, var.tags)
}

resource "aws_s3_bucket_public_access_block" "log_bucket_public_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#------------------------------------------------------------------------------
# Route53 Hosted Zone
#------------------------------------------------------------------------------
resource "aws_route53_zone" "hosted_zone" {
  name = var.website_domain_name
  tags = merge({
    Name = "${var.name_prefix}-hosted-zone"
  }, var.tags)
}
