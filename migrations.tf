# --------------------------------------------------------------------------------------------------
# Migrations to 1.1.0
# Changing the structure - using submodules
# --------------------------------------------------------------------------------------------------

moved {
  from = data.aws_iam_policy_document.assume_role["VerticeGovernanceRole"]
  to   = module.vertice_governance_role[0].data.aws_iam_policy_document.vertice_cur_governance_assume_role
}

moved {
  from = aws_iam_role.base["VerticeGovernanceRole"]
  to   = module.vertice_governance_role[0].aws_iam_role.vertice_governance_role
}



moved {
  from = data.aws_iam_policy_document.custom["VerticeGovernanceRole_CURBucketAccess"]
  to   = module.vertice_governance_role[0].data.aws_iam_policy_document.vertice_cur_bucket_access[0]
}

moved {
  from = aws_iam_policy.custom["VerticeGovernanceRole_CURBucketAccess"]
  to   = module.vertice_governance_role[0].aws_iam_policy.vertice_cur_bucket_access[0]
}

moved {
  from = aws_iam_role_policy_attachment.base["VerticeGovernanceRole_CURBucketAccess"]
  to   = module.vertice_governance_role[0].aws_iam_role_policy_attachment.vertice_cur_bucket_access[0]
}



moved {
  from = data.aws_iam_policy_document.custom["VerticeGovernanceRole_VerticeCoreAccess"]
  to   = module.vertice_governance_role[0].data.aws_iam_policy_document.vertice_core_access
}

moved {
  from = aws_iam_policy.custom["VerticeGovernanceRole_VerticeCoreAccess"]
  to   = module.vertice_governance_role[0].aws_iam_policy.vertice_core_access
}

moved {
  from = aws_iam_role_policy_attachment.base["VerticeGovernanceRole_VerticeCoreAccess"]
  to   = module.vertice_governance_role[0].aws_iam_role_policy_attachment.vertice_core_access
}



moved {
  from = data.aws_iam_policy_document.custom["VerticeGovernanceRole_VerticeCoreSimulate"]
  to   = module.vertice_governance_role[0].data.aws_iam_policy_document.vertice_core_simulate_access
}

moved {
  from = aws_iam_policy.custom["VerticeGovernanceRole_VerticeCoreSimulate"]
  to   = module.vertice_governance_role[0].aws_iam_policy.vertice_core_simulate_access
}

moved {
  from = aws_iam_role_policy_attachment.base["VerticeGovernanceRole_VerticeCoreSimulate"]
  to   = module.vertice_governance_role[0].aws_iam_role_policy_attachment.vertice_core_simulate_access
}


