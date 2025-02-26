variable "alarm_name" {
  description = "The name of the CloudWatch alarm."
  type        = string
}

variable "threshold" {
  description = "The threshold value that triggers the alarm."
  type        = number
}

variable "evaluation_period" {
  description = "The number of evaluation periods before triggering the alarm."
  type        = number
  default     = 1 # Default to 1 period unless overridden
}

variable "period" {
  description = "The time period (in seconds) over which CloudWatch collects data points."
  type        = number
  default     = 60 #
}

variable "sns_topic_arn" {
  description = "The Amazon SNS topic ARN for alarm notifications."
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch Log Group being monitored."
  type        = string
  default     = "/ecs/mood-gif-app"
}