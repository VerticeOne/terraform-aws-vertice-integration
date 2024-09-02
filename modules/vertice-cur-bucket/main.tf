locals {
  s3_policies_from_template = templatefile("${path.module}/buckets_policies.json.tftpl", {
    "cur_bucket_name" = try(var.buckets_configurations["vertice_cur_bucket"]["bucket_name"], "vertice-cur-reports-athena")
    "cor_bucket_name" = try(var.buckets_configurations["vertice_cor_bucket"]["bucket_name"], "vertice-cor-reports")
    "account_id"      = data.aws_caller_identity.current.account_id
  })
  s3_bucket_conf = {
    for bucket_key, bucket_conf in var.buckets_configurations : bucket_key => merge(bucket_conf, {
      policy = jsondecode(local.s3_policies_from_template)[bucket_key]
    })
  }
}

data "aws_caller_identity" "current" {}

module "vertice_cur_bucket" {
  for_each = local.s3_bucket_conf
  source   = "terraform-aws-modules/s3-bucket/aws"
  version  = "3.15.1"

  bucket        = each.value.bucket_name
  force_destroy = each.value.force_destroy_policy

  attach_deny_insecure_transport_policy = each.value.attach_deny_insecure_transport_policy
  attach_policy                         = each.value.attach_policy
  policy                                = jsonencode(each.value.policy)

  versioning     = each.value.bucket_versioning
  lifecycle_rule = each.value.bucket_lifecycle_rules
}
