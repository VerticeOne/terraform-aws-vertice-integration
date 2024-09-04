# --------------------------------------------------------------------------------------------------
# Migrations to 1.1.0
# Changing the structure - Enabled the creation of multiple s3 buckets
# --------------------------------------------------------------------------------------------------

moved {
  from = module.vertice_cur_bucket
  to   = module.vertice_report_buckets["cur"]
}

moved {
  from = data.aws_iam_policy_document.vertice_cur_bucket_access
  to   = data.aws_iam_policy_document.vertice_report_bucket_access["cur"]
}