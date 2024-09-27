variable "data_export_name" {
  default     = "vertice-cor-report"
  description = "The name of the AWS Data Export for Vertice."
  type        = string
}

variable "data_export_bucket_name" {
  description = "The name of the bucket which will be used to store the Cost Optimization Recommendations data for Vertice."
  nullable    = false
  type        = string
}

variable "data_export_s3_prefix" {
  description = "The prefix for the S3 bucket path to where the Cost Optimization Recommendations data will be saved."
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
