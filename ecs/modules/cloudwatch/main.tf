resource "aws_cloudwatch_log_metric_filter" "log_event_count" {
  name           = "LogEventCountFilter"
  pattern        = "[timestamp, message]"  # Match all log events
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "LogEventCount" # Metric name
    namespace = "LogMetrics"    # Custom namespace for the metric
    value     = "1"             # Count each log event as 1
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  threshold           = var.threshold
  period              = var.period
  statistic           = "Sum"
  alarm_description   = "Triggers when log frequency exceeds the threshold."
  treat_missing_data  = "notBreaching" # Avoids triggering on missing data

  # Define the metric to monitor
  metric_name = "LogEventCount" # Must match the metric name in the filter
  namespace  = "LogMetrics"    # Must match the namespace in the filter

  dimensions = {
    LogGroupName = var.log_group_name
  }

  alarm_actions = [var.sns_topic_arn]
}