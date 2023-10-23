variable "vertice_account_ids" {
  type        = list(string)
  description = "List of Account IDs, which are allowed to access the Vertice cross account role."
  default     = ["642184526628", "762729743961"]
}

variable "cur_bucket_name" {
  type        = string
  description = "The name of the bucket which will be used to store the CUR data for Vertice."
  nullable    = true
  default     = null

  validation {
    condition     = var.cur_bucket_name != ""
    error_message = "The cur_bucket_name has to be either null or non-empty string."
  }
}
