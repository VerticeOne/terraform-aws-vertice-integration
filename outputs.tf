output "role_arns" {
  value = {
    for name, role in local.roles : name => aws_iam_role.base[name].arn
  }
}

output "role_names" {
  value = {
    for name, role in local.roles : name => aws_iam_role.base[name].name
  }
}
