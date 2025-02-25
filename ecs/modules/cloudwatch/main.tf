resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = var.alarm_name
  metric_name         = var.metric_name
  namespace           = "AWS/Logs"
  statistic           = "Sum"
  period              = var.period
  evaluation_periods  = var.evaluation_period
  threshold           = var.threshold
  comparison_operator = "GreaterThanThreshold"
  alarm_description   = "This alarm triggers when log frequency is high."

  dimensions = {
    LogGroupName = var.log_group_name
  }
  alarm_actions = [var.sns_topic_arn]
}
