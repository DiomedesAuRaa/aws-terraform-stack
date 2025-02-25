variable "alarm_name" {
  description = "The name of the CloudWatch alarm."
  type        = string
}

variable "metric_name" {
  description = "The metric name for the alarm."
  type        = string
}

variable "threshold" {
  description = "The value at which the alarm will trigger."
  type        = number
}

variable "evaluation_period" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
}

variable "period" {
  description = "The period, in seconds, over which the specified statistic is applied."
  type        = number
}

variable "sns_topic_arn" {
  description = "The SNS topic ARN to send alarm notifications to."
  type        = string
}

variable "log_group_name" {
  description = "The log group name to monitor for the metric."
  type        = string
}
