locals {
  s3_buckets_configurations = {
    cur = {
      bucket_name                           = var.cur_bucket_name
      force_destroy_policy                  = var.cur_bucket_force_destroy
      bucket_versioning                     = var.cur_bucket_versioning
      bucket_lifecycle_rules                = var.cur_bucket_lifecycle_rules
      attach_deny_insecure_transport_policy = true
      attach_policy                         = true
      policy = [
        {
          sid    = "AllowSSLRequestsOnly"
          effect = "Deny"
          action = ["s3:*"]
          resources = [
            "arn:aws:s3:::${var.cur_bucket_name}",
            "arn:aws:s3:::${var.cur_bucket_name}/*"
          ]
          principals = [
            {
              type        = "*"
              identifiers = ["*"]
            }
          ]
          condition = [
            {
              test     = "Bool"
              variable = "aws:SecureTransport"
              values = [
                "false"
              ]
            }
          ]
        },
        {
          sid    = "AllowCURBucketActions"
          effect = "Allow"
          action = [
            "s3:GetBucketAcl",
            "s3:GetBucketPolicy",
          ]
          resources = ["arn:aws:s3:::${var.cur_bucket_name}", ]
          principals = [
            {
              type        = "Service"
              identifiers = ["billingreports.amazonaws.com"]
            }
          ]
          condition = [
            {
              test     = "StringEquals"
              variable = "aws:SourceAccount"
              values   = ["AWS_ACCOUNT_ID"]
            },
            {
              test     = "StringEquals"
              variable = "aws:SourceArn"
              values   = ["arn:aws:cur:us-east-1:AWS_ACCOUNT_ID:definition/*"]
            }
          ]
        },
        {
          sid       = "AllowCURBucketObjectActions"
          effect    = "Allow"
          action    = ["s3:PutObject"]
          resources = ["arn:aws:s3:::${var.cur_bucket_name}/*", ]
          principals = [
            {
              type        = "Service"
              identifiers = ["billingreports.amazonaws.com"]
            }
          ]
          condition = [
            {
              test     = "StringEquals"
              variable = "aws:SourceAccount"
              values   = ["AWS_ACCOUNT_ID"]
            },
            {
              test     = "StringEquals"
              variable = "aws:SourceArn"
              values   = ["arn:aws:cur:us-east-1:AWS_ACCOUNT_ID:definition/*"]
            }
          ]
        }
      ]
      bucket_enabled = var.cur_bucket_enabled
    }
    cor = {
      bucket_name                           = var.cor_bucket_name
      force_destroy_policy                  = var.cor_bucket_force_destroy
      bucket_versioning                     = var.cor_bucket_versioning
      bucket_lifecycle_rules                = var.cor_bucket_lifecycle_rules
      attach_deny_insecure_transport_policy = false
      attach_policy                         = true
      policy = [{
        sid    = "EnableAWSDataExportsToWriteToS3AndCheckPolicy"
        effect = "Allow"
        action = [
          "s3:PutObject",
        "s3:GetBucketPolicy"]
        resources = [
          "arn:aws:s3:::${var.cor_bucket_name}/*",
          "arn:aws:s3:::${var.cor_bucket_name}"
        ]
        principals = [
          {
            type        = "Service"
            identifiers = ["bcm-data-exports.amazonaws.com", "billingreports.amazonaws.com"]
          }
        ]
        condition = [
          {
            test     = "StringLike"
            variable = "aws:SourceAccount"
            values   = ["AWS_ACCOUNT_ID"]
          },
          {
            test     = "StringLike"
            variable = "aws:SourceArn"
            values = [
              "arn:aws:cur:us-east-1:AWS_ACCOUNT_ID:definition/*",
              "arn:aws:bcm-data-exports:us-east-1:AWS_ACCOUNT_ID:export/*",
            ]
          }
        ]
        }
      ]
      bucket_enabled = var.cor_bucket_enabled
    }
  }
  s3_bucket_enabled = contains([var.cur_bucket_enabled, var.cor_bucket_enabled], true)
  s3_buckets_enabled_configuration = {
    for bucket_key, bucket_conf in local.s3_buckets_configurations : bucket_key => bucket_conf
    if bucket_conf.bucket_enabled
  }
}

module "vertice_governance_role" {
  count  = var.governance_role_enabled ? 1 : 0
  source = "./modules/vertice-governance-role"

  report_bucket_names                    = [var.cur_bucket_name, var.cor_bucket_name]
  vertice_account_ids                    = var.vertice_account_ids
  account_type                           = var.account_type
  governance_role_external_id            = var.governance_role_external_id
  governance_role_assume_policy_json     = var.governance_role_assume_policy_json
  governance_role_additional_policy_json = var.governance_role_additional_policy_json
  billing_policy_addons                  = var.billing_policy_addons
}

module "vertice_report_buckets" {
  count  = local.s3_bucket_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-report-buckets"

  buckets_configurations = local.s3_buckets_enabled_configuration
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

  depends_on = [module.vertice_report_buckets]
}

module "vertice_cor_report" {
  count  = var.cor_report_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-cor-report"

  cor_report_name           = var.cor_report_name
  cor_report_bucket_name    = var.cor_bucket_name
  cor_report_s3_prefix      = var.cor_report_s3_prefix
  cor_columns_for_selection = var.cor_columns_for_selection
  cor_table_configurations  = var.cor_table_configurations

  ## COR report is currently available only in the us-east-1 region
  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  depends_on = [module.vertice_report_buckets.aws_s3_bucket_policy]
}