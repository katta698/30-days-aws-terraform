resource "aws_cloudwatch_metric_alarm" "denied_requests" {
  alarm_name          = "${var.project_name}-denied-requests-alarm"
  alarm_description   = "Triggers when S3 AccessDenied or 403 errors are detected."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 1
  datapoints_to_alarm = 1
  threshold           = 1
  period              = 60
  statistic           = "Sum"

  namespace   = var.metric_namespace
  metric_name = var.denied_metric_name

  treat_missing_data = "notBreaching"

  alarm_actions = [
    var.sns_topic_arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "restricted_prefix_access" {
  alarm_name          = "${var.project_name}-restricted-prefix-alarm"
  alarm_description   = "Triggers when objects under the private/ prefix are accessed."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 1
  datapoints_to_alarm = 1
  threshold           = 1
  period              = 60
  statistic           = "Sum"

  namespace   = var.metric_namespace
  metric_name = var.restricted_metric_name

  treat_missing_data = "notBreaching"

  alarm_actions = [
    var.sns_topic_arn
  ]
}