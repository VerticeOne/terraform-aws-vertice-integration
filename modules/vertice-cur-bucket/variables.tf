variable "cur_bucket_name" {
  type        = string
  description = "The name of the bucket which will be used to store the CUR data for Vertice."
}

variable "cur_bucket_force_destroy" {
  type        = string
  description = "The name of the bucket which will be used to store the CUR data for Vertice."
  default     = false
}

variable "cur_bucket_versioning" {
  type        = map(string)
  description = "Map containing versioning configuration on the S3 bucket holding CUR data."
  default = {
    status     = false
    mfa_delete = false
  }
}

variable "cur_bucket_lifecycle_rules" {
  type        = any
  description = "List of maps containing configuration of object lifecycle management on the S3 bucket holding CUR data."
  default     = []
}
