output "vertice_governance_role_arn" {
  description = "The ARN of VerticeGovernance role created."
  value       = aws_iam_role.vertice_governance_role.arn
}

output "vertice_governance_role_name" {
  description = "The name of VerticeGovernance role created."
  value       = aws_iam_role.vertice_governance_role.name
}
