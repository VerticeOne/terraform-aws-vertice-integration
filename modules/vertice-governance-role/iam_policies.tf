locals {
  billing_access_enabled    = contains(["billing", "combined"], var.account_type)
  cur_bucket_access_enabled = local.billing_access_enabled && var.cur_bucket_name != null

  core_access_enabled = contains(["member", "combined"], var.account_type)

  simulate_access_enabled                   = true
  governance_role_additional_policy_enabled = var.governance_role_additional_policy_json != null
}

########
## Managed policy for accessing the CUR bucket
########

data "aws_iam_policy_document" "vertice_cur_bucket_access" {
  count = local.cur_bucket_access_enabled ? 1 : 0

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
  count = local.cur_bucket_access_enabled ? 1 : 0

  name   = "CURBucketAccess"
  policy = data.aws_iam_policy_document.vertice_cur_bucket_access[0].json
}

resource "aws_iam_role_policy_attachment" "vertice_cur_bucket_access" {
  count = local.cur_bucket_access_enabled ? 1 : 0

  role       = aws_iam_role.vertice_governance_role.name
  policy_arn = aws_iam_policy.vertice_cur_bucket_access[0].arn
}

########
## Managed policy for accessing billing resources Vertice needs for AWS Cloud Cost Optimization
########

data "aws_iam_policy_document" "vertice_billing_access" {
  count = local.billing_access_enabled ? 1 : 0

  statement {
    sid = "VerticeBillingAccess"

    effect = "Allow"

    actions = [
      "budgets:Describe*",
      "budgets:View*",
      "ce:Describe*",
      "ce:Get*",
      "ce:List*",
      "cur:Describe*",
      "organizations:Describe*",
      "organizations:List*",
      "savingsplans:Describe*",
      "savingsplans:List*",
    ]

    resources = [
      "*"
    ]
  }

  dynamic "statement" {
    for_each = var.billing_policy_addons.ec2_ri ? [1] : []
    content {
      sid    = "VerticeEc2ReservedInstancesAccess"
      effect = "Allow"
      actions = [
        "ec2:DeleteQueuedReservedInstances",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInstanceTypeOfferings",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeInstances",
        "ec2:DescribeReservedInstances",
        "ec2:DescribeReservedInstancesOfferings",
        "ec2:ModifyReservedInstances",
        "ec2:PurchaseReservedInstancesOffering",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.billing_policy_addons.rds_ri ? [1] : []
    content {
      sid    = "VerticeRdsReservedInstancesAccess"
      effect = "Allow"
      actions = [
        "rds:DescribeDBInstances",
        "rds:DescribeReservedDBInstances",
        "rds:DescribeReservedDBInstancesOfferings",
        "rds:PurchaseReservedDBInstancesOffering",
      ]
      resources = ["*"]
    }
  }
}

resource "aws_iam_policy" "vertice_billing_access" {
  count = local.billing_access_enabled ? 1 : 0

  name   = "VerticeGovernanceRolePolicy"
  policy = data.aws_iam_policy_document.vertice_billing_access[0].json
}

resource "aws_iam_role_policy_attachment" "vertice_billing_access" {
  count = local.billing_access_enabled ? 1 : 0

  role       = aws_iam_role.vertice_governance_role.name
  policy_arn = aws_iam_policy.vertice_billing_access[0].arn
}

########
## Managed policy for accessing workload resources Vertice needs for AWS Cloud Cost Optimization
########

data "aws_iam_policy_document" "vertice_core_access" {
  count = local.core_access_enabled ? 1 : 0

  statement {
    sid = "VerticeCoreAccess"

    effect = "Allow"

    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:List*",
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
      "organizations:Describe*",
      "organizations:List*",
      "rds:Describe*",
      "rds:List*",
      "redshift:Describe*",
      "redshift:View*",
      "s3:GetBucketLocation",
      "s3:GetBucketTagging",
      "s3:List*",
      "savingsplans:Describe*",
      "savingsplans:List*",
      "tag:Get*",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "vertice_core_access" {
  count = local.core_access_enabled ? 1 : 0

  name   = "VerticeCoreAccess"
  policy = data.aws_iam_policy_document.vertice_core_access[0].json
}

resource "aws_iam_role_policy_attachment" "vertice_core_access" {
  count = local.core_access_enabled ? 1 : 0

  role       = aws_iam_role.vertice_governance_role.name
  policy_arn = aws_iam_policy.vertice_core_access[0].arn
}

########
## Managed policy for simulating principal
########

data "aws_iam_policy_document" "vertice_core_simulate_access" {
  count = local.simulate_access_enabled ? 1 : 0

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
  count = local.simulate_access_enabled ? 1 : 0

  name   = "VerticeCoreSimulate"
  policy = data.aws_iam_policy_document.vertice_core_simulate_access[0].json
}

resource "aws_iam_role_policy_attachment" "vertice_core_simulate_access" {
  count = local.simulate_access_enabled ? 1 : 0

  role       = aws_iam_role.vertice_governance_role.name
  policy_arn = aws_iam_policy.vertice_core_simulate_access[0].arn
}

########
## Additional policy specified by the user
########

resource "aws_iam_policy" "vertice_governance_role_additional_policy" {
  count = local.governance_role_additional_policy_enabled ? 1 : 0

  name   = "VerticeAdditionalPolicy"
  policy = var.governance_role_additional_policy_json
}

resource "aws_iam_role_policy_attachment" "vertice_governance_role_additional_policy" {
  count = local.governance_role_additional_policy_enabled ? 1 : 0

  role       = aws_iam_role.vertice_governance_role.name
  policy_arn = aws_iam_policy.vertice_governance_role_additional_policy[0].arn
}
