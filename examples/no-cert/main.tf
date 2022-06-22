module "test_website" {
  source      = "../../"
  name_prefix = "test-website"

  providers = {
    aws.main         = aws.main
    aws.acm_provider = aws.acm_provider
  }

  website_domain_name = "test.com"

  create_acm_certificate     = false
  acm_certificate_arn_to_use = "arn:aws:acm:us-east-1:123456789000:certificate/01234567-89a-bcde-f012-3456789abcde"

  create_route53_hosted_zone = true

  aws_accounts_with_read_view_log_bucket = ["mock_account"]
}
