# vertice-cur-report

Sub-module responsible for the creation of an AWS Cost and Usage Report (CUR).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.64.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.73.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | 5.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cur_report_definition.vertice_cur_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cur_report_definition) | resource |
| [aws_s3_bucket.vertice_cur_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cur_report_bucket_name"></a> [cur\_report\_bucket\_name](#input\_cur\_report\_bucket\_name) | The name of the bucket which will be used to store the CUR data for Vertice. | `string` | n/a | yes |
| <a name="input_cur_report_name"></a> [cur\_report\_name](#input\_cur\_report\_name) | The name of the CUR report for Vertice. | `string` | `"vertice-cur-report"` | no |
| <a name="input_cur_report_s3_prefix"></a> [cur\_report\_s3\_prefix](#input\_cur\_report\_s3\_prefix) | The prefix for the S3 bucket path to where the CUR data will be saved. | `string` | n/a | yes |
| <a name="input_cur_report_split_cost_data"></a> [cur\_report\_split\_cost\_data](#input\_cur\_report\_split\_cost\_data) | Enable Split Cost Allocation Data inclusion in CUR. Note that manual opt-in is needed in AWS Console. | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
