data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "vertice_governance_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.vertice_account_ids)
    }

    dynamic "condition" {
      for_each = compact([var.governance_role_external_id])
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [var.governance_role_external_id]
      }
    }
  }
}

resource "aws_iam_role" "vertice_governance_role" {
  name                 = "VerticeGovernanceRole"
  path                 = "/vertice/"
  max_session_duration = 60 * 60 * 12

  assume_role_policy = data.aws_iam_policy_document.vertice_governance_assume_role.json
}
