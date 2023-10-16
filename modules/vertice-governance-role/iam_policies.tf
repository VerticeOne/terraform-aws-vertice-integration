########
## Managed policy for accessing the CUR bucket
########

data "aws_iam_policy_document" "vertice_cur_bucket_access" {
  count = var.cur_bucket_name == null ? 0 : 1

  statement {
    sid = "CURBucketAccess"

    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.cur_bucket_name}",
      "arn:aws:s3:::${var.cur_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "vertice_cur_bucket_access" {
  count = var.cur_bucket_name == null ? 0 : 1

  name   = "CURBucketAccess"
  policy = data.aws_iam_policy_document.vertice_cur_bucket_access[0].json
}

resource "aws_iam_role_policy_attachment" "vertice_cur_bucket_access" {
  count = var.cur_bucket_name == null ? 0 : 1

  role       = aws_iam_role.vertice_governance_role.name
  policy_arn = aws_iam_policy.vertice_cur_bucket_access[0].arn
}

########
## Managed policy for accessing services Vertice needs for AWS Cloud Cost Optimization
########

data "aws_iam_policy_document" "vertice_core_access" {
  statement {
    sid = "VerticeCoreAccess"

    effect = "Allow"

    actions = [
      "budgets:Describe*",
      "budgets:View*",
      "ec2:Describe*",
      "ec2:GetCapacityReservationUsage",
      "ec2:GetEbsEncryptionByDefault",
      "ec2:List*",
      "ec2:SearchTransitGatewayRoutes",
      "ecr:BatchCheck*",
      "ecr:BatchGet*",
      "ecr:Describe*",
      "ecr:List*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "es:Describe*",
      "es:List*",
      "rds:Describe*",
      "rds:List*",
      "redshift:Describe*",
      "redshift:View*",
      "s3:GetBucketLocation",
      "s3:GetBucketTagging",
      "s3:List*",
      "tag:Get*",
      "ce:Get*",
      "ce:Describe*",
      "ce:List*",
      "cloudwatch:Describe*",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:List*",
      "cur:Describe*",
      "pricing:*",
      "organizations:Describe*",
      "organizations:List*",
      "savingsplans:Describe*",
      "savingsplans:List*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "vertice_core_access" {
  name   = "VerticeCoreAccess"
  policy = data.aws_iam_policy_document.vertice_core_access.json
}

resource "aws_iam_role_policy_attachment" "vertice_core_access" {
  role       = aws_iam_role.vertice_governance_role.name
  policy_arn = aws_iam_policy.vertice_core_access.arn
}

########
## Managed policy for simulating principal
########

data "aws_iam_policy_document" "vertice_core_simulate_access" {
  statement {
    sid = "VerticeCoreSimulateAccess"

    effect = "Allow"

    actions = [
      "iam:SimulatePrincipalPolicy"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/vertice/VerticeGovernanceRole"
    ]
  }
}

resource "aws_iam_policy" "vertice_core_simulate_access" {
  name   = "VerticeCoreSimulate"
  policy = data.aws_iam_policy_document.vertice_core_simulate_access.json
}

resource "aws_iam_role_policy_attachment" "vertice_core_simulate_access" {
  role       = aws_iam_role.vertice_governance_role.name
  policy_arn = aws_iam_policy.vertice_core_simulate_access.arn
}
