# vertice-governance-role

Sub-module responsible for the creation of an IAM role assumable by Vertice.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.vertice_billing_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vertice_core_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vertice_core_simulate_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vertice_cur_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vertice_governance_role_additional_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.vertice_governance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.vertice_billing_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vertice_core_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vertice_core_simulate_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vertice_cur_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vertice_governance_role_additional_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.vertice_billing_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vertice_core_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vertice_core_simulate_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vertice_cur_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vertice_governance_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | The type of the AWS account. The possible values are `billing`, `member` and `combined`.<br>Use `billing` if the target account is only for billing purposes (generating CUR report and exporting it to Vertice via S3 bucket).<br>Use `member` if the account contains active workload and you want to allow `VerticeGovernance` role to perform spend optimization actions in the account on your behalf.<br>Use `combined` for both of the above. | `string` | n/a | yes |
| <a name="input_billing_policy_addons"></a> [billing\_policy\_addons](#input\_billing\_policy\_addons) | Enable optional add-ons for the `billing`/`combined` account IAM policy. | <pre>object({<br>    ec2_ri = optional(bool, true),<br>    rds_ri = optional(bool, true),<br>  })</pre> | `{}` | no |
| <a name="input_cur_bucket_name"></a> [cur\_bucket\_name](#input\_cur\_bucket\_name) | The name of the bucket which will be used to store the CUR data for Vertice. | `string` | `null` | no |
| <a name="input_data_export_enabled"></a> [data\_export\_enabled](#input\_data\_export\_enabled) | Include policy enabling access to AWS Data Exports. | `bool` | `false` | no |
| <a name="input_governance_role_additional_policy_json"></a> [governance\_role\_additional\_policy\_json](#input\_governance\_role\_additional\_policy\_json) | Custom additional policy in JSON format to attach to VerticeGovernance role. Default is `null` for no additional policy. | `string` | `null` | no |
| <a name="input_governance_role_external_id"></a> [governance\_role\_external\_id](#input\_governance\_role\_external\_id) | STS external ID value to require for assuming the governance role. Required if the governance IAM role is to be created. You will receive this from Vertice. | `string` | `""` | no |
| <a name="input_vertice_account_ids"></a> [vertice\_account\_ids](#input\_vertice\_account\_ids) | List of Account IDs, which are allowed to access the Vertice cross account role. | `list(string)` | <pre>[<br>  "642184526628",<br>  "762729743961"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vertice_governance_role_arn"></a> [vertice\_governance\_role\_arn](#output\_vertice\_governance\_role\_arn) | The ARN of VerticeGovernance role created. |
| <a name="output_vertice_governance_role_name"></a> [vertice\_governance\_role\_name](#output\_vertice\_governance\_role\_name) | The name of VerticeGovernance role created. |
<!-- END_TF_DOCS -->
