#------------------------------------------------------------------------------
# Misc
#------------------------------------------------------------------------------
variable "name_prefix" {
  description = "Name prefix for resources on AWS"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

#------------------------------------------------------------------------------
# Website
#------------------------------------------------------------------------------
variable "website_domain_name" {
  description = "The domain name to use for the website"
  type        = string
}

variable "website_bucket_force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "website_index_document" {
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders."
  type        = string
  default     = "index.html"
}

variable "website_error_document" {
  description = "(Optional) An absolute path to the document to return in case of a 4XX error."
  type        = string
  default     = null
}

variable "website_cors_allowed_headers" {
  description = "(Optional) Specifies which headers are allowed. Defaults to Authorization and Content-Length"
  type        = list(string)
  default     = ["Authorization", "Content-Length"]
}

variable "website_cors_allowed_methods" {
  description = "(Optional) Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. Defaults to GET and POST"
  type        = list(string)
  default     = ["GET", "POST"]
}

variable "website_cors_additional_allowed_origins" {
  description = "(Optional) Specifies which origins are allowed besides the domain name specified"
  type        = list(string)
  default     = []
}

variable "website_cors_expose_headers" {
  description = "(Optional) Specifies expose header in the response."
  type        = list(string)
  default     = []
}

variable "website_cors_max_age_seconds" {
  description = "(Optional) Specifies time in seconds that browser can cache the response for a preflight request. Defaults to 3600"
  type        = number
  default     = 3600
}

variable "website_versioning_enabled" {
  description = "(Optional) Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. Defaults to false"
  type        = bool
  default     = false
}

variable "website_versioning_mfa_delete" {
  description = "(Optional) Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version. Default is false. This cannot be used to toggle this setting but is available to allow managed buckets to reflect the state in AWS."
  type        = bool
  default     = false
}

variable "website_acceleration_status" {
  description = "(Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = "Suspended"
}

#------------------------------------------------------------------------------
# WWW Website for redirection to Website
#------------------------------------------------------------------------------
variable "www_website_bucket_force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# Cloudfront
#------------------------------------------------------------------------------
variable "enable_cloudfront" {
  description = "Indicates if Cloudfront should be created or not"
  type        = bool
  default     = true
}
