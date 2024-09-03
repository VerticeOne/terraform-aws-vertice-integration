data "aws_caller_identity" "current" {}

module "vertice_cur_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket        = var.cur_bucket_name
  force_destroy = var.cur_bucket_force_destroy

  attach_deny_insecure_transport_policy = true
  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.vertice_cur_bucket_access.json

  versioning     = var.cur_bucket_versioning
  lifecycle_rule = var.cur_bucket_lifecycle_rules
}