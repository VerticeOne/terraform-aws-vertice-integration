# vertice-cur-bucket

Sub-module responsible for the creation of an S3 bucket for collecting AWS cost and usage data.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.41.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vertice\_report\_buckets"></a> [vertice\_report\_buckets](#module\_vertice\_cur\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.vertice_report_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets_configurations"></a> [buckets\_configurations](#input\_buckets\_configurations)                 | Map of configurations that are needed for creating S3 buckets.                                          | <pre>map(object({</br>    bucket_name</br>         = string</br>    force_destroy_policy = optional(bool, false)</br>    bucket_versioning = optional(map(string), {</br>      status     = false</br>      mfa_delete = false</br>    })</br>    bucket_lifecycle_rules                = optional(any, [])</br>    attach_deny_insecure_transport_policy = optional(bool, false)</br>    attach_policy                         = optional(bool, true)</br>    policy = list(object({</br>      sid       = string</br>      action    = list(string)</br>      effect    = optional(string, "Deny")</br>      resources = optional(list(string), ["*"])</br>      principals = optional(list(object({</br>        type        = string</br>        identifiers = list(string)</br>      })), [])</br>      condition = optional(list(object({</br>        test     = string</br>        variable = string</br>        values   = list(string)</br>      })), [])</br>    }))</br>    bucket_enabled = bool</br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
