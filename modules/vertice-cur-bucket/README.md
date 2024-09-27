# vertice-cur-bucket

Sub-module responsible for the creation of an S3 bucket for collecting AWS cost and usage data.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.41.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vertice_cur_bucket"></a> [vertice\_cur\_bucket](#module\_vertice\_cur\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.vertice_cur_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cur_bucket_allow_data_export_access"></a> [cur\_bucket\_allow\_data\_export\_access](#input\_cur\_bucket\_allow\_data\_export\_access) | Add IAM policy for AWS Data Export access to the bucket. | `bool` | `false` | no |
| <a name="input_cur_bucket_force_destroy"></a> [cur\_bucket\_force\_destroy](#input\_cur\_bucket\_force\_destroy) | The name of the bucket which will be used to store the CUR data for Vertice. | `string` | `false` | no |
| <a name="input_cur_bucket_lifecycle_rules"></a> [cur\_bucket\_lifecycle\_rules](#input\_cur\_bucket\_lifecycle\_rules) | List of maps containing configuration of object lifecycle management on the S3 bucket holding CUR data. | `any` | `[]` | no |
| <a name="input_cur_bucket_name"></a> [cur\_bucket\_name](#input\_cur\_bucket\_name) | The name of the bucket which will be used to store the CUR data for Vertice. | `string` | n/a | yes |
| <a name="input_cur_bucket_versioning"></a> [cur\_bucket\_versioning](#input\_cur\_bucket\_versioning) | Map containing versioning configuration on the S3 bucket holding CUR data. | `map(string)` | <pre>{<br>  "mfa_delete": false,<br>  "status": false<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
