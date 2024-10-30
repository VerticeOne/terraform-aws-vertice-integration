terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.64.0, < 6.0.0"

      # A provider alias for us-east-1 region is needed because CUR is available only there.
      configuration_aliases = [
        aws,
        aws.us-east-1
      ]
    }
  }
}
