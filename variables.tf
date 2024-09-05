########
## General variables
########

variable "vertice_account_ids" {
  type        = list(string)
  description = "List of Account IDs, which are allowed to access the Vertice cross account role."
  default     = ["642184526628", "762729743961"]
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
    ec2_ri = optional(bool, true),
    rds_ri = optional(bool, true),
  })
  default = {}
}

########
## CUR bucket module variables
########

variable "cur_bucket_name" {
  type        = string
  description = "The name of the bucket which will be used to store the CUR data for Vertice."
  default     = null
}

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
  description = "Whether to enable the module that creates S3 buckets for Cost Usage Report data and Cost Optimization Recommendations data."
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

########
## COR report module variables
########

variable "cor_report_enabled" {
  default     = false
  description = "Whether to enable the module that creates S3 bucket for Cost Usage Report data."
  type        = bool
}

variable "cor_report_name" {
  default     = "vertice-cor-report"
  description = "The name of the Cost Optimization Recommendations report for Vertice."
  type        = string
}

variable "cor_report_s3_prefix" {
  description = "The prefix for the S3 bucket path to where the Cost Optimization Recommendations data will be saved."
  default     = "cor"
  type        = string
}

variable "cor_columns_for_selection" {
  default = ["account_id", "action_type", "currency_code", "current_resource_details", "current_resource_summary",
    "current_resource_type", "estimated_monthly_cost_after_discount", "estimated_monthly_cost_before_discount",
    "estimated_monthly_savings_after_discount", "estimated_monthly_savings_before_discount",
    "estimated_savings_percentage_after_discount", "estimated_savings_percentage_before_discount",
    "implementation_effort", "last_refresh_timestamp", "recommendation_id", "recommendation_lookback_period_in_days",
    "recommendation_source", "recommended_resource_details", "recommended_resource_summary", "recommended_resource_type",
  "region", "resource_arn", "restart_needed", "rollback_possible", "tags"]
  description = "The list of names of columns that you want to select from COST_OPTIMIZATION_RECOMMENDATIONS table"
  type        = list(string)
}

variable "cor_table_configurations" {
  description = "The configuration, that allows to change table parameters"
  default = {
    INCLUDE_ALL_RECOMMENDATIONS = "TRUE"
    FILTER                      = "{}"
  }
  type = object({
    INCLUDE_ALL_RECOMMENDATIONS = string
    FILTER                      = string
  })
}

########
## COR bucket module variables
########

variable "cor_bucket_name" {
  type        = string
  description = "The name of the bucket which will be used to store the Cost Optimization Recommendations data for Vertice."
  default     = null
}

variable "cor_bucket_enabled" {
  type        = bool
  description = "Whether to enable the module that creates S3 bucket for Cost Optimization Recommendations data."
  default     = false
}

variable "cor_bucket_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

variable "cor_bucket_versioning" {
  type        = map(string)
  description = "Map containing versioning configuration on the S3 bucket holding Cost Optimization Recommendations data."
  default = {
    status     = false
    mfa_delete = false
  }
}

variable "cor_bucket_lifecycle_rules" {
  type        = any
  description = "List of maps containing configuration of object lifecycle management on the S3 bucket holding Cost Optimization Recommendations data."
  default     = []
}