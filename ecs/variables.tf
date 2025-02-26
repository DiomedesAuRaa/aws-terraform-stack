variable "region" {
  description = "The AWS region to deploy to."
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  default     = "cassius-au-bellona-prod"
}

variable "ecs_task_family" {
  description = "The family name of the ECS task."
  default     = "mood-gif-task-prod"
}

variable "ecs_service_name" {
  description = "The name of the ECS service."
  default     = "tiberius-au-bellona-prod"
}

variable "target_group_arn" {
  description = "ARN of the target group for ALB"
  type        = string
  default     = "arn:aws:elasticloadbalancing:us-east-1:122610514415:targetgroup/ecs-tg/cd6642821c9cfedc"
}