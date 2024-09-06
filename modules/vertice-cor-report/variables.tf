variable "cor_report_name" {
  default     = "vertice-cor-report"
  description = "The name of the Cost Optimization Recommendations report for Vertice."
  type        = string
}

variable "cor_report_bucket_name" {
  description = "The name of the bucket which will be used to store the Cost Optimization Recommendations data for Vertice"
  nullable    = false
  type        = string
}

variable "cor_report_s3_prefix" {
  description = "The prefix for the S3 bucket path to where the Cost Optimization Recommendations data will be saved."
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

  validation {
    condition = contains(["account_id", "action_type", "currency_code", "current_resource_details", "current_resource_summary",
      "current_resource_type", "estimated_monthly_cost_after_discount", "estimated_monthly_cost_before_discount",
      "estimated_monthly_savings_after_discount", "estimated_monthly_savings_before_discount",
      "estimated_savings_percentage_after_discount", "estimated_savings_percentage_before_discount",
      "implementation_effort", "last_refresh_timestamp", "recommendation_id", "recommendation_lookback_period_in_days",
      "recommendation_source", "recommended_resource_details", "recommended_resource_summary", "recommended_resource_type",
    "region", "resource_arn", "restart_needed", "rollback_possible", "tags"], var.cor_columns_for_selection)
    error_message = "Given value not contains any columns from the COST_OPTIMIZATION_RECOMMENDATIONS table"
  }
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