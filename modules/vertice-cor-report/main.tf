locals {
  columns_for_selection = length(var.cor_columns_for_selection) > 0 ? join(", ", var.cor_columns_for_selection) : "*"
}

data "aws_s3_bucket" "vertice_cor_bucket" {
  bucket = var.cor_report_bucket_name
}

resource "aws_bcmdataexports_export" "vertice_cor_report" {
  export {
    name = var.cor_report_name
    data_query {
      query_statement = "SELECT ${local.columns_for_selection} FROM COST_OPTIMIZATION_RECOMMENDATIONS"
      table_configurations = {
        COST_OPTIMIZATION_RECOMMENDATIONS = var.cor_table_configurations
      }
    }
    destination_configurations {
      s3_destination {
        s3_bucket = data.aws_s3_bucket.vertice_cor_bucket.bucket
        s3_prefix = var.cor_report_s3_prefix
        s3_region = data.aws_s3_bucket.vertice_cor_bucket.region
        s3_output_configurations {
          overwrite   = "CREATE_NEW_REPORT"
          format      = "PARQUET"
          compression = "PARQUET"
          output_type = "CUSTOM"
        }
      }
    }

    refresh_cadence {
      frequency = "SYNCHRONOUS"
    }
  }

  provider = aws.us-east-1
}