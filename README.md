# Terraform module to provide Vertice Cloud Cost Optimization service with access to your AWS accounts

This module handles creating a role to be used by Vertice Cloud Cost Optimization service to access your AWS account and access required services and data within it.

## Usage

If the account is your AWS Management account you should configure a [Cost and Usage Reports (CUR)](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) export, and then provide the `cur_bucket_name` variable to allow the role access to the CUR data within S3.

## Configure access for your AWS Management Account with Cost and Usage Reports (CUR) export configured

This is an example of creating a role in your [AWS Organizations management](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_getting-started_concepts.html) account (root/payer) where you host your CUR reports in a S3 bucket which will be accessed by the Vertice cross-account IAM role.

Configuring this module to create CUR S3 bucket and CUR report in your AWS Organizations management (root/payer) account is highly recommended.

For the governance IAM role to be created in your account, an ExternalId needs to be set in the `governance_role_external_id` parameter. You will receive this value from Vertice.

```hcl
data "aws_caller_identity" "current" {}

module "vertice_cco_integration_role" {
  source        = "git::https://github.com/VerticeOne/terraform-aws-vertice-integration.git?ref=<release-version>"

  account_type = "billing"
  cur_bucket_enabled = true
  cur_report_enabled = true

  billing_policy_addons = {
    # allow managing EC2 Reserved Instances in billing policy
    ec2_ri = true
  }

  cur_bucket_name = "vertice-cur-reports-athena-${data.aws_caller_identity.current.account_id}"

  cur_report_name      = "athena"
  cur_report_s3_prefix = "cur"

  governance_role_external_id = "<provided ExternalId value>"

  providers = {
    aws = aws

    aws.us-east-1 = aws.us-east-1
  }
}

terraform {
  required_version = ">= 1.1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.64.0"

      # A provider alias for us-east-1 region is needed because CUR is available only there.
      configuration_aliases = [
        aws,
        aws.us-east-1
      ]
    }
  }
}
```

<!-- markdownlint-disable -->
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
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | The type of the AWS account. The possible values are `billing`, `member` and `combined`.<br>Use `billing` if the target account is only for billing purposes (generating CUR report and exporting it to Vertice via S3 bucket).<br>Use `member` if the account contains active workload and you want to allow `VerticeGovernance` role to perform spend optimization actions in the account on your behalf.<br>Use `combined` for both of the above. | `string` | yes |
| <a name="input_billing_policy_addons"></a> [billing\_policy\_addons](#input\_billing\_policy\_addons) | Enable optional add-ons for the `billing`/`combined` account IAM policy. | <pre>object({<br>    ec2_ri = optional(bool, true),<br>    rds_ri = optional(bool, true),<br>  })</pre> | no |
| <a name="input_cur_bucket_enabled"></a> [cur\_bucket\_enabled](#input\_cur\_bucket\_enabled) | Whether to enable the module that creates S3 bucket for Cost Usage Report data. | `bool` | no |
| <a name="input_cur_bucket_force_destroy"></a> [cur\_bucket\_force\_destroy](#input\_cur\_bucket\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | no |
| <a name="input_cur_bucket_lifecycle_rules"></a> [cur\_bucket\_lifecycle\_rules](#input\_cur\_bucket\_lifecycle\_rules) | List of maps containing configuration of object lifecycle management on the S3 bucket holding CUR data. | `any` | no |
| <a name="input_cur_bucket_name"></a> [cur\_bucket\_name](#input\_cur\_bucket\_name) | The name of the bucket which will be used to store the CUR data for Vertice. | `string` | no |
| <a name="input_cur_bucket_versioning"></a> [cur\_bucket\_versioning](#input\_cur\_bucket\_versioning) | Map containing versioning configuration on the S3 bucket holding CUR data. | `map(string)` | no |
| <a name="input_cur_report_enabled"></a> [cur\_report\_enabled](#input\_cur\_report\_enabled) | Whether to enable the module that creates S3 bucket for Cost Usage Report data. | `bool` | no |
| <a name="input_cur_report_name"></a> [cur\_report\_name](#input\_cur\_report\_name) | The name of the CUR report for Vertice. | `string` | no |
| <a name="input_cur_report_s3_prefix"></a> [cur\_report\_s3\_prefix](#input\_cur\_report\_s3\_prefix) | The prefix for the S3 bucket path to where the CUR data will be saved. | `string` | no |
| <a name="input_governance_role_additional_policy_json"></a> [governance\_role\_additional\_policy\_json](#input\_governance\_role\_additional\_policy\_json) | Custom additional policy in JSON format to attach to VerticeGovernance role. Default is null for no additional policy. | `string` | no |
| <a name="input_governance_role_enabled"></a> [governance\_role\_enabled](#input\_governance\_role\_enabled) | Whether to enable the module that creates VerticeGovernance role for the Cloud Cost Optimization. | `bool` | no |
| <a name="input_governance_role_external_id"></a> [governance\_role\_external\_id](#input\_governance\_role\_external\_id) | STS external ID value to require for assuming the governance role. You will receive this from Vertice. | `string` | no |
| <a name="input_vertice_account_ids"></a> [vertice\_account\_ids](#input\_vertice\_account\_ids) | List of Account IDs, which are allowed to access the Vertice cross account role. | `list(string)` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cur_report_name"></a> [cur\_report\_name](#output\_cur\_report\_name) | Name of the CUR report created. |
| <a name="output_cur_report_s3_prefix"></a> [cur\_report\_s3\_prefix](#output\_cur\_report\_s3\_prefix) | Name of the S3 prefix used by the CUR report. |
| <a name="output_role_arns"></a> [role\_arns](#output\_role\_arns) | This output is DEPRECATED and will be removed in future releases. Use vertice\_governance\_role\_arn instead. |
| <a name="output_role_names"></a> [role\_names](#output\_role\_names) | This output is DEPRECATED and will be removed in future releases. Use vertice\_governance\_role\_name instead. |
| <a name="output_vertice_account_ids"></a> [vertice\_account\_ids](#output\_vertice\_account\_ids) | Account IDs of Vertice allowed to access your AWS resources. |
| <a name="output_vertice_governance_role_arn"></a> [vertice\_governance\_role\_arn](#output\_vertice\_governance\_role\_arn) | The ARN of VerticeGovernance role created. |
| <a name="output_vertice_governance_role_name"></a> [vertice\_governance\_role\_name](#output\_vertice\_governance\_role\_name) | The name of VerticeGovernance role created. |
<!-- END_TF_DOCS -->
<!-- markdownlint-enable -->
