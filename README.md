# Terraform module to provide Vertice Cloud Cost Optimization service with access to your AWS accounts

This module handles creating a role to be used by Vertice Cloud Cost Optimization service to access your AWS account and access required services and data within it.

## Usage
If the account is your AWS Management account you should configure a [Cost and Usage Reports (CUR)](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) export, and then provide the `cur_bucket_name` variable to allow the role access to the CUR data within S3.

## Configure access for your AWS Management Account with Cost and Usage Reports (CUR) export configured
This is an example of creating a role in your [AWS Organizations management](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_getting-started_concepts.html) account (root/payer) where you host your CUR reports in a S3 bucket which will be accessed by the Vertice cross-account IAM role.

Creating the CUR bucket in your AWS Organizations management (root/payer) account is highly recommended.

```hcl
module "vertice_cco_integration_role" {
  source        = "git::https://github.com/VerticeOne/terraform-aws-vertice-integration.git?ref=<release-version>"
cur_bucket_name = "<company>-vertice-cur-reports"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.64.0 |

## Providers

No providers.

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_cur_bucket_enabled"></a> [cur\_bucket\_enabled](#input\_cur\_bucket\_enabled) | Whether to enable the module that creates S3 bucket for Cost Usage Report data. | `bool` | no |
| <a name="input_cur_bucket_force_destroy"></a> [cur\_bucket\_force\_destroy](#input\_cur\_bucket\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | no |
| <a name="input_cur_bucket_lifecycle_rules"></a> [cur\_bucket\_lifecycle\_rules](#input\_cur\_bucket\_lifecycle\_rules) | List of maps containing configuration of object lifecycle management on the S3 bucket holding CUR data. | `any` | no |
| <a name="input_cur_bucket_name"></a> [cur\_bucket\_name](#input\_cur\_bucket\_name) | The name of the bucket which will be used to store the CUR data for Vertice. | `string` | no |
| <a name="input_cur_bucket_versioning"></a> [cur\_bucket\_versioning](#input\_cur\_bucket\_versioning) | Map containing versioning configuration on the S3 bucket holding CUR data. | `map(string)` | no |
| <a name="input_cur_report_enabled"></a> [cur\_report\_enabled](#input\_cur\_report\_enabled) | Whether to enable the module that creates S3 bucket for Cost Usage Report data. | `bool` | no |
| <a name="input_cur_report_name"></a> [cur\_report\_name](#input\_cur\_report\_name) | The name of the CUR report for Vertice. | `string` | no |
| <a name="input_cur_report_s3_prefix"></a> [cur\_report\_s3\_prefix](#input\_cur\_report\_s3\_prefix) | The prefix for the S3 bucket path to where the CUR data will be saved. | `string` | no |
| <a name="input_governance_role_enabled"></a> [governance\_role\_enabled](#input\_governance\_role\_enabled) | Whether to enable the module that creates VerticeGovernance role for the Cloud Cost Optimization. | `bool` | no |
| <a name="input_vertice_account_ids"></a> [vertice\_account\_ids](#input\_vertice\_account\_ids) | List of Account IDs, which are allowed to access the Vertice cross account role. | `list(string)` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arns"></a> [role\_arns](#output\_role\_arns) | This output is DEPRECATED and will be removed in future releases. Use vertice\_governance\_role\_arn instead. |
| <a name="output_role_names"></a> [role\_names](#output\_role\_names) | This output is DEPRECATED and will be removed in future releases. Use vertice\_governance\_role\_name instead. |
| <a name="output_vertice_governance_role_arn"></a> [vertice\_governance\_role\_arn](#output\_vertice\_governance\_role\_arn) | The ARN of VerticeGovernance role created. |
| <a name="output_vertice_governance_role_name"></a> [vertice\_governance\_role\_name](#output\_vertice\_governance\_role\_name) | The name of VerticeGovernance role created. |
<!-- END_TF_DOCS -->
