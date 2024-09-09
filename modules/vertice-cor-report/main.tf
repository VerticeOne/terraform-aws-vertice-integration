locals {
  default_columns_for_selection = ["account_id", "action_type", "currency_code", "current_resource_details", "current_resource_summary",
    "current_resource_type", "estimated_monthly_cost_after_discount", "estimated_monthly_cost_before_discount",
    "estimated_monthly_savings_after_discount", "estimated_monthly_savings_before_discount",
    "estimated_savings_percentage_after_discount", "estimated_savings_percentage_before_discount",
    "implementation_effort", "last_refresh_timestamp", "recommendation_id", "recommendation_lookback_period_in_days",
    "recommendation_source", "recommended_resource_details", "recommended_resource_summary", "recommended_resource_type",
  "region", "resource_arn", "restart_needed", "rollback_possible", "tags"]
  sorted_cor_columns_for_selection_list = sort(var.cor_columns_for_selection)
}

data "aws_s3_bucket" "vertice_cor_bucket" {
  bucket = var.cor_report_bucket_name
}

resource "aws_bcmdataexports_export" "vertice_cor_report" {
  lifecycle {
    precondition {
      condition     = sort(setintersection(local.default_columns_for_selection, var.cor_columns_for_selection)) == local.sorted_cor_columns_for_selection_list
      error_message = "All the columns selected for COR must come from ${join(", ", local.default_columns_for_selection)}."
    }
  }

  export {
    name = var.cor_report_name
    data_query {
      query_statement = "SELECT ${join(", ", local.sorted_cor_columns_for_selection_list)} FROM COST_OPTIMIZATION_RECOMMENDATIONS"
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
          overwrite   = "OVERWRITE_REPORT"
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
