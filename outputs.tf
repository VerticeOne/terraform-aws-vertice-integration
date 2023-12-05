output "cur_report_name" {
  description = "Name of the CUR report created."
  value       = var.cur_report_enabled ? var.cur_report_name : null
}

output "cur_report_s3_prefix" {
  description = "Name of the S3 prefix used by the CUR report."
  value       = var.cur_report_enabled ? var.cur_report_s3_prefix : null
}

output "vertice_account_ids" {
  description = "Account IDs of Vertice allowed to access your AWS resources."
  value       = var.governance_role_enabled ? var.vertice_account_ids : null
}

output "vertice_governance_role_arn" {
  description = "The ARN of VerticeGovernance role created."
  value       = var.governance_role_enabled ? one(module.vertice_governance_role[*].vertice_governance_role_arn) : null
}

output "vertice_governance_role_name" {
  description = "The name of VerticeGovernance role created."
  value       = var.governance_role_enabled ? one(module.vertice_governance_role[*].vertice_governance_role_name) : null
}

########
## The following outputs are DEPRECATED.
## They are here only for the backwards compatibility
########

output "role_arns" {
  description = "This output is DEPRECATED and will be removed in future releases. Use vertice_governance_role_arn instead."
  value       = { "VerticeGovernanceRole" = var.governance_role_enabled ? one(module.vertice_governance_role[*].vertice_governance_role_arn) : null }
}

output "role_names" {
  description = "This output is DEPRECATED and will be removed in future releases. Use vertice_governance_role_name instead."
  value       = { "VerticeGovernanceRole" = var.governance_role_enabled ? one(module.vertice_governance_role[*].vertice_governance_role_name) : null }
}
