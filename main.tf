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
        kms_master_key_id = "aws/s3"
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
