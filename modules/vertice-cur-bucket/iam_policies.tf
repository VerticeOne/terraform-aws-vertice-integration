########
## Managed policy for the CUR bucket to grant R/W access to AWS billingreports
########

locals {
  policies = {
    for bucket_key, bucket_conf in var.buckets_configurations : bucket_key =>
    { policy = [for policy in bucket_conf["policy"] :
      merge(policy, { condition = [for condition in policy["condition"] :
        merge(condition, { values = [for value in condition["values"] :
        replace(value, "AWS_ACCOUNT_ID", data.aws_caller_identity.current.account_id)] })
      if condition["test"] != "Bool"] })
    ] }
  }
}

data "aws_iam_policy_document" "vertice_cur_bucket_access" {
  dynamic "statement" {
    for_each = local.policies
    content {
      sid       = try(statement.value["sid"], false) ? statement.value["sid"] : null
      actions   = statement.value["action"]
      effect    = statement.value["effect"]
      resources = statement.value["resources"]
      dynamic "condition" {
        for_each = try(statement.value["condition"], false) ? toset(statement.value["condition"]) : []
        content {
          test     = condition.value["test"]
          values   = condition.value["values"]
          variable = condition.value["variable"]
        }
      }
      dynamic "principals" {
        for_each = try(statement.value["principals"], false) ? toset(statement.value["principals"]) : []
        content {
          type        = principals.value["type"]
          identifiers = principals.value["identifiers"]
        }
      }
    }
  }
}
