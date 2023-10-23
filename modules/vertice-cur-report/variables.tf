variable "cur_report_name" {
  type        = string
  description = "The name of the CUR report for Vertice."
  default     = "vertice-cur-report"
}

variable "cur_report_bucket_name" {
  type        = string
  description = "The name of the bucket which will be used to store the CUR data for Vertice."
}

variable "cur_report_s3_prefix" {
  type        = string
  description = "The prefix for the S3 bucket path to where the CUR data will be saved."
  default     = ""
}
