########
## Managed policy for the CUR bucket to grant R/W access to AWS billingreports and bcm-data-exports
########

data "aws_iam_policy_document" "vertice_cur_bucket_access" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${var.cur_bucket_name}",
      "arn:aws:s3:::${var.cur_bucket_name}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }

  statement {
    sid = "AllowCURBucketActions"

    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
    ]

    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    resources = [
      "arn:aws:s3:::${var.cur_bucket_name}",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cur:us-east-1:${data.aws_caller_identity.current.account_id}:definition/*",
      ]
    }
  }

  statement {
    sid = "AllowCURBucketObjectActions"

    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    resources = [
      "arn:aws:s3:::${var.cur_bucket_name}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cur:us-east-1:${data.aws_caller_identity.current.account_id}:definition/*",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.cur_bucket_allow_data_export_access ? [1] : []

    content {
      sid = "EnableAWSDataExportsToWriteToS3AndCheckPolicy"

      effect = "Allow"

      actions = [
        "s3:PutObject",
        "s3:GetBucketPolicy"
      ]

      principals {
        type = "Service"
        identifiers = [
          "billingreports.amazonaws.com",
          "bcm-data-exports.amazonaws.com"
        ]
      }

      resources = [
        "arn:aws:s3:::${var.cur_bucket_name}",
        "arn:aws:s3:::${var.cur_bucket_name}/*"
      ]

      condition {
        test     = "StringLike"
        variable = "aws:SourceAccount"
        values = [
          data.aws_caller_identity.current.account_id,
        ]
      }

      condition {
        test     = "StringLike"
        variable = "aws:SourceArn"
        values = [
          "arn:aws:cur:us-east-1:${data.aws_caller_identity.current.account_id}:definition/*",
          "arn:aws:bcm-data-exports:us-east-1:${data.aws_caller_identity.current.account_id}:export/*"
        ]
      }
    }
  }
}
