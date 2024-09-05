data "aws_s3_bucket" "vertice_cur_bucket" {
  bucket = var.cur_report_bucket_name
}

resource "aws_cur_report_definition" "vertice_cur_report" {
  report_name = var.cur_report_name
  time_unit   = "HOURLY"

  format      = "Parquet"
  compression = "Parquet"

  additional_schema_elements = concat(
    ["RESOURCES"],
    var.cur_report_split_cost_data ? ["SPLIT_COST_ALLOCATION_DATA"] : [],
  )

  s3_bucket = data.aws_s3_bucket.vertice_cur_bucket.bucket
  s3_region = data.aws_s3_bucket.vertice_cur_bucket.region
  s3_prefix = var.cur_report_s3_prefix

  additional_artifacts = ["ATHENA"]
  report_versioning    = "OVERWRITE_REPORT"

  provider = aws.us-east-1
}
