output "cur_report_name" {
  description = "Name of the CUR report created."
  value       = var.cur_report_enabled ? var.cur_report_name : null
}

output "cur_report_s3_prefix" {
  description = "Name of the S3 prefix used by the CUR report."
  value       = var.cur_report_enabled ? var.cur_report_s3_prefix : null
}

output "data_export_name" {
  description = "Name of the COR report created."
  value       = var.data_export_enabled ? var.data_export_name : null
}

output "data_export_s3_prefix" {
  description = "Name of the S3 prefix used by the COR report."
  value       = var.data_export_enabled ? var.data_export_s3_prefix : null
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
