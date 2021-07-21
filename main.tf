#------------------------------------------------------------------------------
# Locals
#------------------------------------------------------------------------------
locals {
  website_bucket_name     = var.website_domain_name
  www_website_bucket_name = "www.${var.website_domain_name}"
}


resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.name_prefix}-log-bucket"
  acl    = "log-delivery-write"

  tags = merge({
    Name = "${var.name_prefix}-logs"
  }, var.tags)
}

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




