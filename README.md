# AWS S3 Static Website #

This Terraform module the required infrastructure to host an static website on S3.

[![](https://github.com/cn-terraform/terraform-aws-s3-static-website/workflows/terraform/badge.svg)](https://github.com/cn-terraform/terraform-aws-s3-static-website/actions?query=workflow%3Aterraform)
[![](https://img.shields.io/github/license/cn-terraform/terraform-aws-s3-static-website)](https://github.com/cn-terraform/terraform-aws-s3-static-website)
[![](https://img.shields.io/github/issues/cn-terraform/terraform-aws-s3-static-website)](https://github.com/cn-terraform/terraform-aws-s3-static-website)
[![](https://img.shields.io/github/issues-closed/cn-terraform/terraform-aws-s3-static-website)](https://github.com/cn-terraform/terraform-aws-s3-static-website)
[![](https://img.shields.io/github/languages/code-size/cn-terraform/terraform-aws-s3-static-website)](https://github.com/cn-terraform/terraform-aws-s3-static-website)
[![](https://img.shields.io/github/repo-size/cn-terraform/terraform-aws-s3-static-website)](https://github.com/cn-terraform/terraform-aws-s3-static-website)

## Usage

Check versions for this module on:
* Github Releases: <https://github.com/cn-terraform/terraform-aws-s3-static-website/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/s3-static-website/aws>

## Install pre commit hooks.

Pleas run this command right after cloning the repository.

        pre-commit install

For that you may need to install the folowwing tools:
* [Pre-commit](https://pre-commit.com/) 
* [Terraform Docs](https://terraform-docs.io/)

In order to run all checks at any point run the following command:

        pre-commit run --all-files

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.50.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_distribution.www_website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_route53_record.website_cloudfront_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.website_s3_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.www_website_cloudfront_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.www_website_s3_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_s3_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.www_website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [template_file.website_bucket_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.www_website_bucket_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront_allowed_cached_methods"></a> [cloudfront\_allowed\_cached\_methods](#input\_cloudfront\_allowed\_cached\_methods) | (Optional) Specifies which methods are allowed and cached by CloudFront. Can be GET, PUT, POST, DELETE or HEAD. Defaults to GET and HEAD | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_cloudfront_default_root_object"></a> [cloudfront\_default\_root\_object](#input\_cloudfront\_default\_root\_object) | (Optional) - The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. Defaults to index.html | `string` | `"index.html"` | no |
| <a name="input_cloudfront_geo_restriction_locations"></a> [cloudfront\_geo\_restriction\_locations](#input\_cloudfront\_geo\_restriction\_locations) | (Optional) - The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist). Defaults to [] | `list(string)` | `[]` | no |
| <a name="input_cloudfront_geo_restriction_type"></a> [cloudfront\_geo\_restriction\_type](#input\_cloudfront\_geo\_restriction\_type) | The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist. Defaults to none | `string` | `"none"` | no |
| <a name="input_cloudfront_http_version"></a> [cloudfront\_http\_version](#input\_cloudfront\_http\_version) | (Optional) - The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2. | `string` | `"http2"` | no |
| <a name="input_cloudfront_origin_http_port"></a> [cloudfront\_origin\_http\_port](#input\_cloudfront\_origin\_http\_port) | The HTTP port the custom origin listens on. Defaults to 80 | `number` | `80` | no |
| <a name="input_cloudfront_origin_https_port"></a> [cloudfront\_origin\_https\_port](#input\_cloudfront\_origin\_https\_port) | The HTTPS port the custom origin listens on. Defaults to 443 | `number` | `443` | no |
| <a name="input_cloudfront_origin_protocol_policy"></a> [cloudfront\_origin\_protocol\_policy](#input\_cloudfront\_origin\_protocol\_policy) | The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer. | `string` | `"match-viewer"` | no |
| <a name="input_cloudfront_origin_ssl_protocols"></a> [cloudfront\_origin\_ssl\_protocols](#input\_cloudfront\_origin\_ssl\_protocols) | The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. A list of one or more of SSLv3, TLSv1, TLSv1.1, and TLSv1.2. Defaults to TLSv1, TLSv1.1 and TLSv1.2 | `list(string)` | <pre>[<br>  "TLSv1",<br>  "TLSv1.1",<br>  "TLSv1.2"<br>]</pre> | no |
| <a name="input_cloudfront_price_class"></a> [cloudfront\_price\_class](#input\_cloudfront\_price\_class) | (Optional) - The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100. Defaults to PriceClass\_100 | `string` | `"PriceClass_100"` | no |
| <a name="input_cloudfront_viewer_certificate_ssl_support_method"></a> [cloudfront\_viewer\_certificate\_ssl\_support\_method](#input\_cloudfront\_viewer\_certificate\_ssl\_support\_method) | Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only. Required if you specify acm\_certificate\_arn or iam\_certificate\_id. NOTE: vip causes CloudFront to use a dedicated IP address and may incur extra charges. | `string` | `"sni-only"` | no |
| <a name="input_cloudfront_website_retain_on_delete"></a> [cloudfront\_website\_retain\_on\_delete](#input\_cloudfront\_website\_retain\_on\_delete) | (Optional) - Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. Defaults to false. | `bool` | `false` | no |
| <a name="input_cloudfront_website_wait_for_deployment"></a> [cloudfront\_website\_wait\_for\_deployment](#input\_cloudfront\_website\_wait\_for\_deployment) | (Optional) - If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. Defaults to true. | `bool` | `true` | no |
| <a name="input_cloudfront_www_website_retain_on_delete"></a> [cloudfront\_www\_website\_retain\_on\_delete](#input\_cloudfront\_www\_website\_retain\_on\_delete) | (Optional) - Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. Defaults to false. | `bool` | `false` | no |
| <a name="input_cloudfront_www_website_wait_for_deployment"></a> [cloudfront\_www\_website\_wait\_for\_deployment](#input\_cloudfront\_www\_website\_wait\_for\_deployment) | (Optional) - If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. Defaults to true. | `bool` | `true` | no |
| <a name="input_comment_for_cloudfront_website"></a> [comment\_for\_cloudfront\_website](#input\_comment\_for\_cloudfront\_website) | Comment for the Website CloudFront Distribution | `string` | `""` | no |
| <a name="input_comment_for_cloudfront_www_website"></a> [comment\_for\_cloudfront\_www\_website](#input\_comment\_for\_cloudfront\_www\_website) | Comment for the WWW Website CloudFront Distribution | `string` | `""` | no |
| <a name="input_enable_cloudfront"></a> [enable\_cloudfront](#input\_enable\_cloudfront) | Indicates if Cloudfront should be created or not | `bool` | `true` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | (Optional) - Whether the IPv6 is enabled for the distribution. Defaults to true | `bool` | `true` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for resources on AWS | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_website_bucket_force_destroy"></a> [website\_bucket\_force\_destroy](#input\_website\_bucket\_force\_destroy) | (Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| <a name="input_website_cors_additional_allowed_origins"></a> [website\_cors\_additional\_allowed\_origins](#input\_website\_cors\_additional\_allowed\_origins) | (Optional) Specifies which origins are allowed besides the domain name specified | `list(string)` | `[]` | no |
| <a name="input_website_cors_allowed_headers"></a> [website\_cors\_allowed\_headers](#input\_website\_cors\_allowed\_headers) | (Optional) Specifies which headers are allowed. Defaults to Authorization and Content-Length | `list(string)` | <pre>[<br>  "Authorization",<br>  "Content-Length"<br>]</pre> | no |
| <a name="input_website_cors_allowed_methods"></a> [website\_cors\_allowed\_methods](#input\_website\_cors\_allowed\_methods) | (Optional) Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. Defaults to GET and POST | `list(string)` | <pre>[<br>  "GET",<br>  "POST"<br>]</pre> | no |
| <a name="input_website_cors_expose_headers"></a> [website\_cors\_expose\_headers](#input\_website\_cors\_expose\_headers) | (Optional) Specifies expose header in the response. | `list(string)` | `[]` | no |
| <a name="input_website_cors_max_age_seconds"></a> [website\_cors\_max\_age\_seconds](#input\_website\_cors\_max\_age\_seconds) | (Optional) Specifies time in seconds that browser can cache the response for a preflight request. Defaults to 3600 | `number` | `3600` | no |
| <a name="input_website_domain_name"></a> [website\_domain\_name](#input\_website\_domain\_name) | The domain name to use for the website | `string` | n/a | yes |
| <a name="input_website_error_document"></a> [website\_error\_document](#input\_website\_error\_document) | (Optional) An absolute path to the document to return in case of a 4XX error. Defaults to 404.html | `string` | `"404.html"` | no |
| <a name="input_website_index_document"></a> [website\_index\_document](#input\_website\_index\_document) | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders.  Defaults to index.html | `string` | `"index.html"` | no |
| <a name="input_website_versioning_enabled"></a> [website\_versioning\_enabled](#input\_website\_versioning\_enabled) | (Optional) Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. Defaults to false | `bool` | `false` | no |
| <a name="input_website_versioning_mfa_delete"></a> [website\_versioning\_mfa\_delete](#input\_website\_versioning\_mfa\_delete) | (Optional) Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version. Default is false. This cannot be used to toggle this setting but is available to allow managed buckets to reflect the state in AWS. | `bool` | `false` | no |
| <a name="input_www_website_bucket_force_destroy"></a> [www\_website\_bucket\_force\_destroy](#input\_www\_website\_bucket\_force\_destroy) | (Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_website_arn"></a> [cloudfront\_website\_arn](#output\_cloudfront\_website\_arn) | The ARN (Amazon Resource Name) for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID. |
| <a name="output_cloudfront_website_caller_reference"></a> [cloudfront\_website\_caller\_reference](#output\_cloudfront\_website\_caller\_reference) | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| <a name="output_cloudfront_website_domain_name"></a> [cloudfront\_website\_domain\_name](#output\_cloudfront\_website\_domain\_name) | The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net. |
| <a name="output_cloudfront_website_etag"></a> [cloudfront\_website\_etag](#output\_cloudfront\_website\_etag) | The current version of the distribution's information. For example: E2QWRUHAPOMQZL. |
| <a name="output_cloudfront_website_hosted_zone_id"></a> [cloudfront\_website\_hosted\_zone\_id](#output\_cloudfront\_website\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2. |
| <a name="output_cloudfront_website_id"></a> [cloudfront\_website\_id](#output\_cloudfront\_website\_id) | The identifier for the distribution. For example: EDFDVBD632BHDS5. |
| <a name="output_cloudfront_website_in_progress_validation_batches"></a> [cloudfront\_website\_in\_progress\_validation\_batches](#output\_cloudfront\_website\_in\_progress\_validation\_batches) | The number of invalidation batches currently in progress. |
| <a name="output_cloudfront_website_last_modified_time"></a> [cloudfront\_website\_last\_modified\_time](#output\_cloudfront\_website\_last\_modified\_time) | The date and time the distribution was last modified. |
| <a name="output_cloudfront_website_status"></a> [cloudfront\_website\_status](#output\_cloudfront\_website\_status) | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system. |
| <a name="output_cloudfront_website_tags_all"></a> [cloudfront\_website\_tags\_all](#output\_cloudfront\_website\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_cloudfront_website_trusted_key_groups"></a> [cloudfront\_website\_trusted\_key\_groups](#output\_cloudfront\_website\_trusted\_key\_groups) | List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs |
| <a name="output_cloudfront_website_trusted_signers"></a> [cloudfront\_website\_trusted\_signers](#output\_cloudfront\_website\_trusted\_signers) | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs |
| <a name="output_cloudfront_www_website_arn"></a> [cloudfront\_www\_website\_arn](#output\_cloudfront\_www\_website\_arn) | The ARN (Amazon Resource Name) for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID. |
| <a name="output_cloudfront_www_website_caller_reference"></a> [cloudfront\_www\_website\_caller\_reference](#output\_cloudfront\_www\_website\_caller\_reference) | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| <a name="output_cloudfront_www_website_domain_name"></a> [cloudfront\_www\_website\_domain\_name](#output\_cloudfront\_www\_website\_domain\_name) | The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net. |
| <a name="output_cloudfront_www_website_etag"></a> [cloudfront\_www\_website\_etag](#output\_cloudfront\_www\_website\_etag) | The current version of the distribution's information. For example: E2QWRUHAPOMQZL. |
| <a name="output_cloudfront_www_website_hosted_zone_id"></a> [cloudfront\_www\_website\_hosted\_zone\_id](#output\_cloudfront\_www\_website\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2. |
| <a name="output_cloudfront_www_website_id"></a> [cloudfront\_www\_website\_id](#output\_cloudfront\_www\_website\_id) | The identifier for the distribution. For example: EDFDVBD632BHDS5. |
| <a name="output_cloudfront_www_website_in_progress_validation_batches"></a> [cloudfront\_www\_website\_in\_progress\_validation\_batches](#output\_cloudfront\_www\_website\_in\_progress\_validation\_batches) | The number of invalidation batches currently in progress. |
| <a name="output_cloudfront_www_website_last_modified_time"></a> [cloudfront\_www\_website\_last\_modified\_time](#output\_cloudfront\_www\_website\_last\_modified\_time) | The date and time the distribution was last modified. |
| <a name="output_cloudfront_www_website_status"></a> [cloudfront\_www\_website\_status](#output\_cloudfront\_www\_website\_status) | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system. |
| <a name="output_cloudfront_www_website_tags_all"></a> [cloudfront\_www\_website\_tags\_all](#output\_cloudfront\_www\_website\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_cloudfront_www_website_trusted_key_groups"></a> [cloudfront\_www\_website\_trusted\_key\_groups](#output\_cloudfront\_www\_website\_trusted\_key\_groups) | List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs |
| <a name="output_cloudfront_www_website_trusted_signers"></a> [cloudfront\_www\_website\_trusted\_signers](#output\_cloudfront\_www\_website\_trusted\_signers) | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The Hosted Zone ID. This can be referenced by zone records. |
| <a name="output_hosted_zone_name_servers"></a> [hosted\_zone\_name\_servers](#output\_hosted\_zone\_name\_servers) | A list of name servers in associated (or default) delegation set. Find more about delegation sets in AWS docs. |
| <a name="output_hosted_zone_tags_all"></a> [hosted\_zone\_tags\_all](#output\_hosted\_zone\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_route_53_record_website_fqdn"></a> [route\_53\_record\_website\_fqdn](#output\_route\_53\_record\_website\_fqdn) | FQDN built using the zone domain and name. |
| <a name="output_route_53_record_website_name"></a> [route\_53\_record\_website\_name](#output\_route\_53\_record\_website\_name) | The name of the record. |
| <a name="output_route_53_record_www_website_fqdn"></a> [route\_53\_record\_www\_website\_fqdn](#output\_route\_53\_record\_www\_website\_fqdn) | FQDN built using the zone domain and name. |
| <a name="output_route_53_record_www_website_name"></a> [route\_53\_record\_www\_website\_name](#output\_route\_53\_record\_www\_website\_name) | The name of the record. |
| <a name="output_website_bucket_arn"></a> [website\_bucket\_arn](#output\_website\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_website_bucket_domain_name"></a> [website\_bucket\_domain\_name](#output\_website\_bucket\_domain\_name) | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |
| <a name="output_website_bucket_hosted_zone_id"></a> [website\_bucket\_hosted\_zone\_id](#output\_website\_bucket\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_website_bucket_id"></a> [website\_bucket\_id](#output\_website\_bucket\_id) | The name of the bucket. |
| <a name="output_website_bucket_region"></a> [website\_bucket\_region](#output\_website\_bucket\_region) | The AWS region this bucket resides in. |
| <a name="output_website_bucket_regional_domain_name"></a> [website\_bucket\_regional\_domain\_name](#output\_website\_bucket\_regional\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| <a name="output_website_bucket_tags_all"></a> [website\_bucket\_tags\_all](#output\_website\_bucket\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_website_bucket_website_domain"></a> [website\_bucket\_website\_domain](#output\_website\_bucket\_website\_domain) | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| <a name="output_website_bucket_website_endpoint"></a> [website\_bucket\_website\_endpoint](#output\_website\_bucket\_website\_endpoint) | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |
| <a name="output_www_website_bucket_arn"></a> [www\_website\_bucket\_arn](#output\_www\_website\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_www_website_bucket_domain_name"></a> [www\_website\_bucket\_domain\_name](#output\_www\_website\_bucket\_domain\_name) | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |
| <a name="output_www_website_bucket_hosted_zone_id"></a> [www\_website\_bucket\_hosted\_zone\_id](#output\_www\_website\_bucket\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_www_website_bucket_id"></a> [www\_website\_bucket\_id](#output\_www\_website\_bucket\_id) | The name of the bucket. |
| <a name="output_www_website_bucket_region"></a> [www\_website\_bucket\_region](#output\_www\_website\_bucket\_region) | The AWS region this bucket resides in. |
| <a name="output_www_website_bucket_regional_domain_name"></a> [www\_website\_bucket\_regional\_domain\_name](#output\_www\_website\_bucket\_regional\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| <a name="output_www_website_bucket_tags_all"></a> [www\_website\_bucket\_tags\_all](#output\_www\_website\_bucket\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_www_website_bucket_website_domain"></a> [www\_website\_bucket\_website\_domain](#output\_www\_website\_bucket\_website\_domain) | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| <a name="output_www_website_bucket_website_endpoint"></a> [www\_website\_bucket\_website\_endpoint](#output\_www\_website\_bucket\_website\_endpoint) | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
