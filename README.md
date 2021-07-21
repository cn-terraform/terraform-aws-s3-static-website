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
| [aws_s3_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.www_website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [template_file.website_bucket_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.www_website_bucket_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for resources on AWS | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_website_acceleration_status"></a> [website\_acceleration\_status](#input\_website\_acceleration\_status) | (Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended. | `string` | `"Suspended"` | no |
| <a name="input_website_bucket_force_destroy"></a> [website\_bucket\_force\_destroy](#input\_website\_bucket\_force\_destroy) | (Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| <a name="input_website_cors_additional_allowed_origins"></a> [website\_cors\_additional\_allowed\_origins](#input\_website\_cors\_additional\_allowed\_origins) | (Optional) Specifies which origins are allowed besides the domain name specified | `list(string)` | `[]` | no |
| <a name="input_website_cors_allowed_headers"></a> [website\_cors\_allowed\_headers](#input\_website\_cors\_allowed\_headers) | (Optional) Specifies which headers are allowed. Defaults to Authorization and Content-Length | `list(string)` | <pre>[<br>  "Authorization",<br>  "Content-Length"<br>]</pre> | no |
| <a name="input_website_cors_allowed_methods"></a> [website\_cors\_allowed\_methods](#input\_website\_cors\_allowed\_methods) | (Optional) Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. Defaults to GET and POST | `list(string)` | <pre>[<br>  "GET",<br>  "POST"<br>]</pre> | no |
| <a name="input_website_cors_expose_headers"></a> [website\_cors\_expose\_headers](#input\_website\_cors\_expose\_headers) | (Optional) Specifies expose header in the response. | `list(string)` | `[]` | no |
| <a name="input_website_cors_max_age_seconds"></a> [website\_cors\_max\_age\_seconds](#input\_website\_cors\_max\_age\_seconds) | (Optional) Specifies time in seconds that browser can cache the response for a preflight request. Defaults to 3600 | `number` | `3600` | no |
| <a name="input_website_domain_name"></a> [website\_domain\_name](#input\_website\_domain\_name) | The domain name to use for the website | `string` | n/a | yes |
| <a name="input_website_error_document"></a> [website\_error\_document](#input\_website\_error\_document) | (Optional) An absolute path to the document to return in case of a 4XX error. | `string` | `null` | no |
| <a name="input_website_index_document"></a> [website\_index\_document](#input\_website\_index\_document) | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders. | `string` | `"index.html"` | no |
| <a name="input_website_versioning_enabled"></a> [website\_versioning\_enabled](#input\_website\_versioning\_enabled) | (Optional) Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. Defaults to false | `bool` | `false` | no |
| <a name="input_website_versioning_mfa_delete"></a> [website\_versioning\_mfa\_delete](#input\_website\_versioning\_mfa\_delete) | (Optional) Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version. Default is false. This cannot be used to toggle this setting but is available to allow managed buckets to reflect the state in AWS. | `bool` | `false` | no |
| <a name="input_www_website_bucket_force_destroy"></a> [www\_website\_bucket\_force\_destroy](#input\_www\_website\_bucket\_force\_destroy) | (Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
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
