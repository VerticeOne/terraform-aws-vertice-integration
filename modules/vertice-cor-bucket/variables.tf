variable "cor_bucket_name" {
  type        = string
  description = "The name of the bucket which will be used to store the COR data for Vertice."
  nullable    = false
}

variable "cor_bucket_force_destroy" {
  type        = string
  description = "The name of the bucket which will be used to store the COR data for Vertice."
  default     = true
}

variable "cor_bucket_versioning" {
  type        = map(string)
  description = "Map containing versioning configuration on the S3 bucket holding COR data."
  default = {
    status     = false
    mfa_delete = false
  }
}

variable "cor_bucket_lifecycle_rules" {
  type        = any
  description = "List of maps containing configuration of object lifecycle management on the S3 bucket holding COR data."
  default     = []
}
