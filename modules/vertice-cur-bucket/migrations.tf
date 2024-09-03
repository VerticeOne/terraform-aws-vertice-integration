moved {
  from = module.vertice_cur_bucket
  to   = module.vertice_cur_bucket["vertice_cur_bucket"]
}

moved {
  from = data.aws_iam_policy_document.vertice_cur_bucket_access
  to   = data.aws_iam_policy_document.vertice_cur_bucket_access["vertice_cur_bucket"]
}