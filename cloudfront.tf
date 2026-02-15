###################################
# CloudFront Origin Access Identity
###################################
resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  provider = aws.main

  comment = "OAI to restrict access to AWS S3 content"
}
