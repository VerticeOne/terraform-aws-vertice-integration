# vertice-cor-report

Sub-module responsible for the creation of an AWS Cost and Usage Report (CUR).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version   |
|------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.64.0 |

## Providers

| Name | Version   |
|------|-----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.64.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | >= 5.64.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_bcmdataexports_export.vertice_cor_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bcmdataexports_export) | resource |
| [aws_s3_bucket.vertice_cur_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket)                      | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cor_report_bucket_name"></a> [cor\_report\_bucket\_name](#input\_cor\_report\_bucket\_name)          | The name of the bucket which will be used to store the Cost Optimization Recommendations data for Vertice. | `string`                                                                                                               | n/a                                                                                                          |   yes    |
| <a name="input_cor_report_name"></a> [cor\_report\_name](#input\_cor\_report\_name)                                 | The name of the Cost Optimization Recommendations report for Vertice.                                      | `string`                                                                                                               | `"vertice-cor-report"`                                                                                       |    no    |
| <a name="input_cor_report_s3_prefix"></a> [cor\_report\_s3\_prefix](#input\_cor\_report\_s3\_prefix)                | The prefix for the S3 bucket path to where the Cost Optimization Recommendations data will be saved.       | `string`                                                                                                               | n/a                                                                                                          |   yes    |
| <a name="input_cor_table_configurations"></a> [cor\_table\_configurations](#input\_cor\_table\_configurations)      | The configuration, that allows to change table parameters                                                  | <pre>object({</br>    INCLUDE_ALL_RECOMMENDATIONS = string</br>    FILTER                      = string</br>  })</pre> | <pre>{</br>    INCLUDE_ALL_RECOMMENDATIONS = "TRUE"</br>    FILTER                      = "{}"</br>  }</pre> |    no    |
| <a name="input_cor_columns_for_selection"></a> [cor\_columns\_for\_selection](#input\_cor\_columns\_for\_selection) | The list of names of columns that you want to select from COST_OPTIMIZATION_RECOMMENDATIONS table.         | `list(string)`                                                                                                         | `[]`                                                                                                         |    no    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->