module "test_website" {
  source      = "../../"
  name_prefix = "test-website"

  providers = {
    aws.main         = aws.main
    aws.acm_provider = aws.acm_provider
  }

  website_domain_name    = "test.com"
  enable_cloudfront      = true
  create_acm_certificate = true
}
