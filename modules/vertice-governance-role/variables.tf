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

variable "governance_role_external_id" {
  type        = string
  description = "STS external ID value to require for assuming the governance role. Required if the governance IAM role is to be created. You will receive this from Vertice."
  default     = ""
}

variable "governance_role_additional_policy_json" {
  type        = string
  description = "Custom additional policy in JSON format to attach to VerticeGovernance role. Default is `null` for no additional policy."
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

variable "billing_policy_addons" {
  description = "Enable optional add-ons for the `billing`/`combined` account IAM policy."
  type = object({
    ec2_ri = optional(bool, true),
    rds_ri = optional(bool, true),
  })
  default = {}
}
