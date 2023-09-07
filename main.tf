locals {
  default_role = {
    max_session_duration = 3600
    aws_policies         = []
    managed_policies     = {}
    inline_policies      = {}
  }
  static_roles = {
    "VerticeGovernanceRole" = {
      assume_role_principals = [{
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", var.vertice_account_ids)
      }]
      max_session_duration = 43200
      managed_policies = {
        CURBucketAccess = {
          actions = [
            "s3:GetBucketLocation",
            "s3:ListBucket",
            "s3:GetObject"
          ]
          resources = ["arn:aws:s3:::${var.cur_bucket_name}",
          "arn:aws:s3:::${var.cur_bucket_name}/*"]
        },
        VerticeCoreAccess = {
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
        },
        VerticeCoreSimulate = {
          actions = [
            "iam:SimulatePrincipalPolicy"
          ]
          resources = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/VerticeGovernanceRole"
          ]
        }
      }
    }
  }

  roles = { for name, role in local.static_roles : name => merge(local.default_role, role) }
  inline_policies = {
    for p in flatten([
      for role_name, role in local.roles : [
        for policy_name, policy in role.inline_policies : [
          { "${role_name}_${policy_name}" : { role_name = role_name, role = role, policy_name = policy_name, policy = policy } }
        ]
      ]
    ]) : keys(p)[0] => values(p)[0]
  }
  managed_policies = {
    for p in flatten([
      for role_name, role in local.roles : [
        for policy_name, policy in role.managed_policies : [
          { "${role_name}_${policy_name}" : { role_name = role_name, role = role, policy_name = policy_name, policy = policy } }
        ]
      ]
    ]) : keys(p)[0] => values(p)[0]
  }
  role_policy_attachments = {
    for rp in flatten([
      for role_name, role in local.roles : [
        concat(
          [for policy_arn in role.aws_policies : [
            { "${role_name}_${policy_arn}" : { role = role_name, policy = "${policy_arn}" } }
          ]],
          [for policy_name, policy in role.managed_policies : [
            { "${role_name}_${policy_name}" : { role = role_name, policy = aws_iam_policy.custom["${role_name}_${policy_name}"].arn } }
          ]],
        )
      ]
    ]) : keys(rp)[0] => values(rp)[0]
  }
}

resource "aws_iam_role" "base" {
  for_each = local.roles

  name = each.key

  max_session_duration = each.value.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role[each.key].json
}

resource "aws_iam_role_policy" "inline" {
  for_each = local.inline_policies

  name   = each.key
  role   = each.value.role_name
  policy = data.aws_iam_policy_document.inline[each.key].json
}

data "aws_iam_policy_document" "assume_role" {
  for_each = local.roles

  dynamic "statement" {
    for_each = each.value.assume_role_principals

    content {
      principals {
        type        = statement.value["type"]
        identifiers = statement.value["identifiers"]
      }
      actions = ["sts:AssumeRole"]
    }
  }
}

data "aws_iam_policy_document" "inline" {
  for_each = local.inline_policies
  statement {
    actions   = each.value.policy.actions
    resources = each.value.policy.resources
  }
}

resource "aws_iam_role_policy_attachment" "base" {
  for_each   = local.role_policy_attachments
  role       = aws_iam_role.base[each.value.role].name
  policy_arn = each.value.policy
}

resource "aws_iam_policy" "custom" {
  for_each = local.managed_policies
  name     = each.value.policy_name

  policy = data.aws_iam_policy_document.custom[each.key].json
}

data "aws_iam_policy_document" "custom" {
  for_each = local.managed_policies
  statement {
    actions   = each.value.policy.actions
    resources = each.value.policy.resources
  }
}

data "aws_caller_identity" "current" {}
