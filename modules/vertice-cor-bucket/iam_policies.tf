########
## Managed policy for the CUR bucket to grant R/W access to AWS billingreports
########

data "aws_iam_policy_document" "vertice_cor_bucket_access" {
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
      "arn:aws:s3:::${var.cor_bucket_name}",
      "arn:aws:s3:::${var.cor_bucket_name}/*"
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
    sid = "EnableAWSDataExportsToWriteToS3AndCheckPolicy"

    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetBucketPolicy"
    ]

    principals {
      type        = "Service"
      identifiers = ["bcm-data-exports.amazonaws.com", "billingreports.amazonaws.com"]
    }

    resources = [
      "arn:aws:s3:::${var.cor_bucket_name}/*",
      "arn:aws:s3:::${var.cor_bucket_name}"
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
        "arn:aws:bcm-data-exports:us-east-1:${data.aws_caller_identity.current.account_id}:export/*",
      ]
    }
  }
}
