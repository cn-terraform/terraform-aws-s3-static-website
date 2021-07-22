module "test_website" {
  source              = "../../"
  name_prefix         = "test-website"
  website_domain_name = "test.com"
  enable_cloudfront   = true
}
