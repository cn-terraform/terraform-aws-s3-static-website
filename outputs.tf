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
