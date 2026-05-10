locals {
  metric_namespace       = "S3SecurityMonitoring"
  denied_metric_name     = "DeniedRequests"
  restricted_metric_name = "RestrictedPrefixAccess"
}

resource "aws_cloudwatch_log_metric_filter" "denied_requests" {
  name           = "s3-denied-requests"
  log_group_name = var.log_group_name

  pattern = "{ ($.errorCode = \"AccessDenied\") || ($.errorCode = \"403\") }"

  metric_transformation {
    name      = local.denied_metric_name
    namespace = local.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "restricted_prefix_access" {
  name           = "s3-restricted-prefix-access"
  log_group_name = var.log_group_name

  pattern = "{ ($.eventSource = \"s3.amazonaws.com\") && ($.requestParameters.key = \"private/*\") }"

  metric_transformation {
    name      = local.restricted_metric_name
    namespace = local.metric_namespace
    value     = "1"
  }
}