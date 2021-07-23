provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "mock_access_key" # tfsec:ignore:AWS044
  secret_key                  = "mock_secret_key" # tfsec:ignore:GEN003
  alias                       = "main"
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "mock_access_key" # tfsec:ignore:AWS044
  secret_key                  = "mock_secret_key" # tfsec:ignore:GEN003
  alias                       = "acm_provider"
}
