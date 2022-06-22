module "test_website" {
  source      = "../../"
  name_prefix = "test-website"

  providers = {
    aws.main         = aws.main
    aws.acm_provider = aws.acm_provider
  }

  website_domain_name = "test.com"

  create_acm_certificate = true

  create_route53_hosted_zone = true

  aws_accounts_with_read_view_log_bucket = ["mock_account"]
}
