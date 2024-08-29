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
  default     = []
  description = "The list of names of columns that you want to select from COST_OPTIMIZATION_RECOMMENDATIONS table"
  type        = list(string)
}

variable "cor_table_configurations" {
  description = "The configuration, that allows to change table parameters"
  default = {
    include_all_recommendations = true
    filter                      = "null"
  }
  type = object({
    include_all_recommendations = bool
    filter                      = string
  })
}