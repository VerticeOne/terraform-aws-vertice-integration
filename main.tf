module "vertice_governance_role" {
  count  = var.governance_role_enabled ? 1 : 0
  source = "./modules/vertice-governance-role"

  cur_bucket_name     = var.cur_bucket_name
  vertice_account_ids = var.vertice_account_ids
}

module "vertice_cur_bucket" {
  count  = var.cur_bucket_enabled ? 1 : 0
  source = "./modules/vertice-cur-bucket"

  cur_bucket_name            = var.cur_bucket_name
  cur_bucket_force_destroy   = var.cur_bucket_force_destroy
  cur_bucket_versioning      = var.cur_bucket_versioning
  cur_bucket_lifecycle_rules = var.cur_bucket_lifecycle_rules
}

module "vertice_cur_report" {
  count  = var.cur_report_enabled ? 1 : 0
  source = "./modules/vertice-cur-report"

  cur_report_name        = var.cur_report_name
  cur_report_bucket_name = var.cur_bucket_name
  cur_report_s3_prefix   = var.cur_report_s3_prefix

  ## CUR report is currently available only in the us-east-1 region
  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }
}
