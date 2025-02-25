variable "region" {
  description = "The AWS region to deploy to."
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  default     = "cassius-au-bellona-test"
}

variable "ecs_task_family" {
  description = "The family name of the ECS task."
  default     = "julian-au-bellona"
}

variable "ecs_service_name" {
  description = "The name of the ECS service."
  default     = "tiberius-au-bellona"
}

