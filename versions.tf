terraform {
  required_version = ">= 1.5.5"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~>6"
      configuration_aliases = [aws.main, aws.acm_provider]
    }
  }
}
