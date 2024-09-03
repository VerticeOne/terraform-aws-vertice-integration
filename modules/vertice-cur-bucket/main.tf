data "aws_caller_identity" "current" {}

module "vertice_cur_bucket" {
  for_each = var.buckets_configurations
  source   = "terraform-aws-modules/s3-bucket/aws"
  version  = "3.15.1"

  bucket        = each.value.bucket_name
  force_destroy = each.value.force_destroy_policy

  attach_deny_insecure_transport_policy = each.value.attach_deny_insecure_transport_policy
  attach_policy                         = each.value.attach_policy
  policy                                = local.policies[each.key]

  versioning     = each.value.bucket_versioning
  lifecycle_rule = each.value.bucket_lifecycle_rules
}
