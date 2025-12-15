# Create the CloudWatch Log Group
resource "aws_cloudwatch_log_group" "log_group" {
  name = var.log_group_name
}

# Metric Filter referencing the created log group
resource "aws_cloudwatch_log_metric_filter" "log_event_count" {
  name           = "LogEventCountFilter"
  pattern        = "[timestamp, message]" # Match all log events
  log_group_name = aws_cloudwatch_log_group.log_group.name

  metric_transformation {
    name      = "LogEventCount"
    namespace = "LogMetrics"
    value     = "1"
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
  treat_missing_data  = "notBreaching"

  # Define the metric to monitor
  metric_name = "LogEventCount"
  namespace   = "LogMetrics"

  dimensions = {
    LogGroupName = aws_cloudwatch_log_group.log_group.name
  }

  alarm_actions = [var.sns_topic_arn]
}
