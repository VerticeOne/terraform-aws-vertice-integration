########
## General variables
########

variable "vertice_account_ids" {
  type        = list(string)
  description = "List of Account IDs, which are allowed to access the Vertice cross account role."
  default     = ["642184526628", "762729743961"]
}

variable "cur_bucket_name" {
  type        = string
  description = "The name of the bucket which will be used to store the CUR data for Vertice."
  default     = null
}

variable "account_type" {
  description = <<-EOT
    The type of the AWS account. The possible values are `billing`, `member` and `combined`.
    Use `billing` if the target account is only for billing purposes (generating CUR report and exporting it to Vertice via S3 bucket).
    Use `member` if the account contains active workload and you want to allow `VerticeGovernance` role to perform spend optimization actions in the account on your behalf.
    Use `combined` for both of the above.
  EOT
  type        = string
}

########
## Governance Role module variables
########

variable "governance_role_enabled" {
  type        = bool
  description = "Whether to enable the module that creates VerticeGovernance role for the Cloud Cost Optimization."
  default     = true
}

variable "governance_role_additional_policy_json" {
  type        = string
  description = "Custom additional policy in JSON format to attach to VerticeGovernance role. Default is null for no additional policy."
  default     = null
}

variable "billing_policy_addons" {
  description = "Enable optional add-ons for the `billing`/`combined` account IAM policy."
  type = object({
    ec2_ri = optional(bool, true),
    rds_ri = optional(bool, true),
  })
  default = {}
}

variable sts_external_id {
  type        = string
  description = "The external ID to be used in the STS AssumeRole API call. This is used to prevent the confused deputy problem."
  default     = null
}

########
## CUR bucket module variables
########

variable "cur_bucket_enabled" {
  type        = bool
  description = "Whether to enable the module that creates S3 bucket for Cost Usage Report data."
  default     = false
}

variable "cur_bucket_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
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

########
## CUR report module variables
########

variable "cur_report_enabled" {
  type        = bool
  description = "Whether to enable the module that creates S3 bucket for Cost Usage Report data."
  default     = false
}

variable "cur_report_name" {
  type        = string
  description = "The name of the CUR report for Vertice."
  default     = "vertice-cur-report"
}

variable "cur_report_s3_prefix" {
  type        = string
  description = "The prefix for the S3 bucket path to where the CUR data will be saved."
  default     = "cur"
}
