module "vertice_governance_role" {
  count  = var.governance_role_enabled ? 1 : 0
  source = "./modules/vertice-governance-role"

  cur_bucket_name                        = var.cur_bucket_name
  data_export_enabled                    = var.data_export_enabled
  vertice_account_ids                    = var.vertice_account_ids
  account_type                           = var.account_type
  governance_role_external_id            = var.governance_role_external_id
  governance_role_assume_policy_json     = var.governance_role_assume_policy_json
  governance_role_additional_policy_json = var.governance_role_additional_policy_json
  billing_policy_addons                  = var.billing_policy_addons
}

module "vertice_cur_bucket" {
  count  = var.cur_bucket_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-cur-bucket"

  cur_bucket_name            = var.cur_bucket_name
  cur_bucket_force_destroy   = var.cur_bucket_force_destroy
  cur_bucket_versioning      = var.cur_bucket_versioning
  cur_bucket_lifecycle_rules = var.cur_bucket_lifecycle_rules

  cur_bucket_allow_data_export_access = var.data_export_enabled
}

module "vertice_cur_report" {
  count  = var.cur_report_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-cur-report"

  cur_report_name        = var.cur_report_name
  cur_report_bucket_name = var.cur_bucket_name
  cur_report_s3_prefix   = var.cur_report_s3_prefix

  cur_report_split_cost_data = var.cur_report_split_cost_data

  ## CUR report is currently available only in the us-east-1 region
  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  depends_on = [module.vertice_cur_bucket]
}

module "vertice_aws_data_export" {
  count  = var.data_export_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-aws-data-export"

  data_export_name         = var.data_export_name
  data_export_bucket_name  = var.cur_bucket_name
  data_export_s3_prefix    = var.data_export_s3_prefix
  data_export_columns      = var.data_export_columns
  data_export_table_config = var.data_export_table_config

  ## AWS Data Export is currently only available in the us-east-1 region
  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  depends_on = [module.vertice_cur_bucket]
}
