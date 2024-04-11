data "aws_caller_identity" "current" {}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "vertice_cco_integration_role" {
  source = "../"

  account_type       = "combined"
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
