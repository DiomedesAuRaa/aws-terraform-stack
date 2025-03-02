# Create the CloudWatch Log Group
resource "aws_cloudwatch_log_group" "log_group" {
  name = var.log_group_name
}

# Metric Filter referencing the created log group
resource "aws_cloudwatch_log_metric_filter" "log_event_count" {
  name           = "LogEventCountFilter"
  pattern        = "[timestamp, message]"  # Match all log events
  log_group_name = aws_cloudwatch_log_group.log_group.name  # Reference the created log group

  metric_transformation {
    name      = "LogEventCount" # Metric name
    namespace = "LogMetrics"    # Custom namespace for the metric
    value     = "1"             # Count each log event as 1
  }
}

# CloudWatch Metric Alarm referencing the created log group
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
    LogGroupName = aws_cloudwatch_log_group.log_group.name  # Reference the created log group
  }

  alarm_actions = [var.sns_topic_arn]
}