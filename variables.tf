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

variable "governance_role_external_id" {
  type        = string
  description = "STS external ID value to require for assuming the governance role. Required if the governance IAM role is to be created. You will receive this from Vertice."
  default     = ""
}

variable "governance_role_assume_policy_json" {
  type        = string
  description = "Optional override for VerticeGovernanceRole assume policy. Default assume role policy is constructed if this is not provided."
  default     = null
}

variable "governance_role_additional_policy_json" {
  type        = string
  description = "Custom additional policy in JSON format to attach to VerticeGovernance role. Default is null for no additional policy."
  default     = null
}

variable "billing_policy_addons" {
  description = "Enable optional add-ons for the `billing`/`combined` account IAM policy."
  type = object({
    elasticache_ri = optional(bool, true),
    ec2_ri         = optional(bool, true),
    es_ri          = optional(bool, true),
    rds_ri         = optional(bool, true),
    redshift_ri    = optional(bool, true),
    saving_plans   = optional(bool, true),
  })
  default = {}
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

variable "cur_report_split_cost_data" {
  type        = bool
  description = "Enable Split Cost Allocation Data inclusion in CUR. Note that manual opt-in is needed in AWS Console."
  default     = false
}

########
## AWS Data Export module variables
########

variable "data_export_enabled" {
  default     = false
  description = "Enable AWS Data Export functionality."
  type        = bool
}

variable "data_export_name" {
  default     = "vertice-cor-report"
  description = "The name of the AWS Data Export created for Vertice."
  type        = string
}

variable "data_export_s3_prefix" {
  description = "The prefix for the S3 bucket path where the AWS Data Export data will be saved."
  default     = "cor"
  type        = string
}

variable "data_export_columns" {
  default     = []
  description = "List of column names to select from the COST_OPTIMIZATION_RECOMMENDATIONS table."
  type        = list(string)
}

variable "data_export_table_config" {
  description = "COR table configurations; see https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-cor.html for details."
  default = {
    INCLUDE_ALL_RECOMMENDATIONS = "TRUE"
    FILTER                      = "{}"
  }
  type = object({
    INCLUDE_ALL_RECOMMENDATIONS = string
    FILTER                      = string
  })
}
