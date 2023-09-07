# Terraform Repository used to manage the Vertice CCO Role

This module handles linking an AWS account with your Vertice account.

## Usage
This module configures an AWS Account role to be used for integration with Vertice. If the account is your root AWS account you should configure a CUR integration, and provide the `cur_bucket_name` variable to allow access to the CUR data.
