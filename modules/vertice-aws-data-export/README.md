# vertice-aws-data-export

Sub-module responsible for the creation of an [AWS Data Export](https://docs.aws.amazon.com/cur/latest/userguide/what-is-data-exports.html). The `Cost optimization recommendations` format of data is currently supported.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.64.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | >= 5.64.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_bcmdataexports_export.vertice_cor_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bcmdataexports_export) | resource |
| [aws_s3_bucket.vertice_cor_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_export_bucket_name"></a> [data\_export\_bucket\_name](#input\_data\_export\_bucket\_name) | The name of the bucket which will be used to store the Cost Optimization Recommendations data for Vertice. | `string` | n/a | yes |
| <a name="input_data_export_columns"></a> [data\_export\_columns](#input\_data\_export\_columns) | List of column names to select from the COST\_OPTIMIZATION\_RECOMMENDATIONS table. | `list(string)` | `[]` | no |
| <a name="input_data_export_name"></a> [data\_export\_name](#input\_data\_export\_name) | The name of the AWS Data Export for Vertice. | `string` | `"vertice-cor-report"` | no |
| <a name="input_data_export_s3_prefix"></a> [data\_export\_s3\_prefix](#input\_data\_export\_s3\_prefix) | The prefix for the S3 bucket path to where the Cost Optimization Recommendations data will be saved. | `string` | n/a | yes |
| <a name="input_data_export_table_config"></a> [data\_export\_table\_config](#input\_data\_export\_table\_config) | COR table configurations; see https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-cor.html for details. | <pre>object({<br>    INCLUDE_ALL_RECOMMENDATIONS = string<br>    FILTER                      = string<br>  })</pre> | <pre>{<br>  "FILTER": "{}",<br>  "INCLUDE_ALL_RECOMMENDATIONS": "TRUE"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
