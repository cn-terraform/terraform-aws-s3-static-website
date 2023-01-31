#------------------------------------------------------------------------------
# Website S3 Bucket
#------------------------------------------------------------------------------
output "website_bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.website.id
}

output "website_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.website.arn
}

output "website_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = aws_s3_bucket.website.bucket_domain_name
}

output "website_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer to https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoints when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "website_bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = aws_s3_bucket.website.hosted_zone_id
}

output "website_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = aws_s3_bucket.website.region
}

output "website_bucket_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3_bucket.website.tags_all
}

#------------------------------------------------------------------------------
# Logs S3 Bucket
#------------------------------------------------------------------------------
output "website_logs_bucket_id" {
  description = "The name of the bucket which holds the access logs"
  value       = module.s3_logs_bucket.s3_bucket_id
}

#------------------------------------------------------------------------------
# Cloudfront for S3 Bucket Website
#------------------------------------------------------------------------------
output "cloudfront_website_id" {
  description = "The identifier for the distribution. For example: EDFDVBD632BHDS5."
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_website_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID."
  value       = aws_cloudfront_distribution.website.arn
}

output "cloudfront_website_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = aws_cloudfront_distribution.website.caller_reference
}

output "cloudfront_website_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = aws_cloudfront_distribution.website.status
}

output "cloudfront_website_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudfront_distribution.website.tags_all
}

output "cloudfront_website_trusted_key_groups" {
  description = "List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs"
  value       = aws_cloudfront_distribution.website.trusted_key_groups
}

output "cloudfront_website_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = aws_cloudfront_distribution.website.trusted_signers
}

output "cloudfront_website_domain_name" {
  description = "The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net."
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_website_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = aws_cloudfront_distribution.website.last_modified_time
}

output "cloudfront_website_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = aws_cloudfront_distribution.website.in_progress_validation_batches
}

output "cloudfront_website_etag" {
  description = "The current version of the distribution's information. For example: E2QWRUHAPOMQZL."
  value       = aws_cloudfront_distribution.website.etag
}

output "cloudfront_website_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2."
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}

#------------------------------------------------------------------------------
# Route53 Hosted Zone
#------------------------------------------------------------------------------
output "hosted_zone_id" {
  description = "The Hosted Zone ID. This can be referenced by zone records."
  value       = var.create_route53_hosted_zone ? aws_route53_zone.hosted_zone[0].zone_id : var.route53_hosted_zone_id
}

output "hosted_zone_name_servers" {
  description = "A list of name servers in the associated (or default) delegation set. Find more about delegation sets in AWS docs."
  value       = var.create_route53_hosted_zone ? aws_route53_zone.hosted_zone[0].name_servers : []
}

output "hosted_zone_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = var.create_route53_hosted_zone ? aws_route53_zone.hosted_zone[0].tags_all : {}
}

output "route_53_record_website_name" {
  description = "The name of the record."
  value       = var.create_route53_website_records == true ? aws_route53_record.website_cloudfront_record[0].name : null
}

output "route_53_record_website_fqdn" {
  description = "FQDN built using the zone domain and name."
  value       = var.create_route53_website_records == true ? aws_route53_record.website_cloudfront_record[0].fqdn : null
}

output "route_53_record_www_website_name" {
  description = "The name of the record."
  value       = (var.www_website_redirect_enabled && var.create_route53_website_records) ? aws_route53_record.www_website_record[0].name : null
}

output "route_53_record_www_website_fqdn" {
  description = "FQDN built using the zone domain and name."
  value       = (var.www_website_redirect_enabled && var.create_route53_website_records) ? aws_route53_record.www_website_record[0].fqdn : null
}

#------------------------------------------------------------------------------
# ACM Certificate
#------------------------------------------------------------------------------
output "acm_certificate_id" {
  description = "The ARN of the certificate"
  value       = var.create_acm_certificate ? aws_acm_certificate.cert[0].id : var.acm_certificate_arn_to_use
}

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = var.create_acm_certificate ? aws_acm_certificate.cert[0].arn : var.acm_certificate_arn_to_use
}

output "acm_certificate_domain_name" {
  description = "The domain name for which the certificate is issued"
  value       = var.create_acm_certificate ? aws_acm_certificate.cert[0].domain_name : ""
}

output "acm_certificate_domain_validation_options" {
  description = "Set of domain validation objects which can be used to complete certificate validation. Can have more than one element, e.g. if SANs are defined."
  value       = var.create_acm_certificate ? aws_acm_certificate.cert[0].domain_validation_options : []
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = var.create_acm_certificate ? aws_acm_certificate.cert[0].status : ""
}

output "acm_certificate_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = var.create_acm_certificate ? aws_acm_certificate.cert[0].tags_all : {}
}

output "cert_validation_certificate_arn" {
  description = "The ARN of the certificate that is being validated."
  value       = var.create_acm_certificate ? aws_acm_certificate_validation.cert_validation[0].certificate_arn : ""
}

output "cert_validation_validation_record_fqdns" {
  description = "List of FQDNs that implement the validation."
  value       = var.create_acm_certificate ? aws_acm_certificate_validation.cert_validation[0].validation_record_fqdns : []
}

output "cert_validation_id" {
  description = "The time at which the certificate was issued"
  value       = var.create_acm_certificate ? aws_acm_certificate_validation.cert_validation[0].id : ""
}
