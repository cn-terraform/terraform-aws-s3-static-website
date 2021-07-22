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
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
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

output "website_bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = aws_s3_bucket.website.website_endpoint
}

output "website_bucket_website_domain" {
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
  value       = aws_s3_bucket.website.website_domain
}

#------------------------------------------------------------------------------
# S3 Bucket for redirection from URL with www to the one without www
#------------------------------------------------------------------------------
output "www_website_bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.www_website.id
}

output "www_website_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.www_website.arn
}

output "www_website_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = aws_s3_bucket.www_website.bucket_domain_name
}

output "www_website_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = aws_s3_bucket.www_website.bucket_regional_domain_name
}

output "www_website_bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = aws_s3_bucket.www_website.hosted_zone_id
}

output "www_website_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = aws_s3_bucket.www_website.region
}

output "www_website_bucket_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3_bucket.www_website.tags_all
}

output "www_website_bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = aws_s3_bucket.www_website.website_endpoint
}

output "www_website_bucket_website_domain" {
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
  value       = aws_s3_bucket.www_website.website_domain
}

#------------------------------------------------------------------------------
# Cloudfront for S3 Bucket Website
#------------------------------------------------------------------------------
output "cloudfront_website_id" {
  description = "The identifier for the distribution. For example: EDFDVBD632BHDS5."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].id : null
}

output "cloudfront_website_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].arn : null
}

output "cloudfront_website_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].caller_reference : null
}

output "cloudfront_website_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].status : null
}

output "cloudfront_website_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].tags_all : null
}

output "cloudfront_website_trusted_key_groups" {
  description = "List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].trusted_key_groups : null
}

output "cloudfront_website_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].trusted_signers : null
}

output "cloudfront_website_domain_name" {
  description = "The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].domain_name : null
}

output "cloudfront_website_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].last_modified_time : null
}

output "cloudfront_website_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].in_progress_validation_batches : null
}

output "cloudfront_website_etag" {
  description = "The current version of the distribution's information. For example: E2QWRUHAPOMQZL."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].etag : null
}

output "cloudfront_website_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].hosted_zone_id : null
}

#------------------------------------------------------------------------------
# Cloudfront for S3 Bucket for WWW Website Redirection
#------------------------------------------------------------------------------
output "cloudfront_www_website_id" {
  description = "The identifier for the distribution. For example: EDFDVBD632BHDS5."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].id : null
}

output "cloudfront_www_website_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].arn : null
}

output "cloudfront_www_website_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].caller_reference : null
}

output "cloudfront_www_website_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].status : null
}

output "cloudfront_www_website_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].tags_all : null
}

output "cloudfront_www_website_trusted_key_groups" {
  description = "List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].trusted_key_groups : null
}

output "cloudfront_www_website_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].trusted_signers : null
}

output "cloudfront_www_website_domain_name" {
  description = "The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].domain_name : null
}

output "cloudfront_www_website_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].last_modified_time : null
}

output "cloudfront_www_website_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].in_progress_validation_batches : null
}

output "cloudfront_www_website_etag" {
  description = "The current version of the distribution's information. For example: E2QWRUHAPOMQZL."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].etag : null
}

output "cloudfront_www_website_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2."
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.www_website[0].hosted_zone_id : null
}

#------------------------------------------------------------------------------
# Route53 Hosted Zone
#------------------------------------------------------------------------------
output "hosted_zone_id" {
  description = "The Hosted Zone ID. This can be referenced by zone records."
  value       = aws_route53_zone.hosted_zone.zone_id
}

output "hosted_zone_name_servers" {
  description = "A list of name servers in associated (or default) delegation set. Find more about delegation sets in AWS docs."
  value       = aws_route53_zone.hosted_zone.name_servers
}

output "hosted_zone_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53_zone.hosted_zone.tags_all
}

output "route_53_record_website_name" {
  description = "The name of the record."
  value       = var.enable_cloudfront ? aws_route53_record.website_cloudfront_record[0].name : aws_route53_record.website_s3_record[0].name
}

output "route_53_record_website_fqdn" {
  description = "FQDN built using the zone domain and name."
  value       = var.enable_cloudfront ? aws_route53_record.website_cloudfront_record[0].fqdn : aws_route53_record.website_s3_record[0].fqdn
}

output "route_53_record_www_website_name" {
  description = "The name of the record."
  value       = var.enable_cloudfront ? aws_route53_record.www_website_cloudfront_record[0].name : aws_route53_record.www_website_s3_record[0].name
}

output "route_53_record_www_website_fqdn" {
  description = "FQDN built using the zone domain and name."
  value       = var.enable_cloudfront ? aws_route53_record.www_website_cloudfront_record[0].fqdn : aws_route53_record.www_website_s3_record[0].fqdn
}
