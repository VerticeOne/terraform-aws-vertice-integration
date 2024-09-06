########
## Managed policy for the CUR and COR bucket to grant R/W access to AWS billingreports and bcm-data-exports
########

locals {
  policies = {
    for bucket_key, bucket_conf in var.buckets_configurations : bucket_key =>
    [for policy in bucket_conf["policy"] :
      merge(policy, { condition = [for condition in policy["condition"] :
        merge(condition, { values = [for value in condition["values"] :
        replace(value, "AWS_ACCOUNT_ID", data.aws_caller_identity.current.account_id)] })
      ] })
  ] }
}

data "aws_iam_policy_document" "vertice_report_bucket_access" {
  for_each = local.policies
  dynamic "statement" {
    for_each = each.value
    content {
      sid       = can(statement.value["sid"]) ? statement.value["sid"] : null
      actions   = statement.value["action"]
      effect    = statement.value["effect"]
      resources = statement.value["resources"]
      dynamic "condition" {
        for_each = can(statement.value["condition"]) ? toset(statement.value["condition"]) : []
        content {
          test     = condition.value["test"]
          values   = condition.value["values"]
          variable = condition.value["variable"]
        }
      }
      dynamic "principals" {
        for_each = can(statement.value["principals"]) ? toset(statement.value["principals"]) : []
        content {
          type        = principals.value["type"]
          identifiers = principals.value["identifiers"]
        }
      }
    }
  }
}
