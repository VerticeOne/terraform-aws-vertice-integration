########
## Managed policy for the CUR bucket to grant R/W access to AWS billingreports
########

data "aws_iam_policy_document" "vertice_cur_bucket_access" {
  count = var.cur_bucket_name == null ? 0 : 1

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
}
