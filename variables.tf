variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "my-ecs-cluster"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "my-lambda-function"
}

variable "enable_eks" {
  description = "Enable or disable the EKS module"
  type        = bool
  default     = true
}

variable "enable_ec2" {
  description = "Enable or disable the EC2 module"
  type        = bool
  default     = true
}

variable "enable_rds" {
  description = "Enable or disable the RDS module"
  type        = bool
  default     = true
}

variable "enable_s3" {
  description = "Enable or disable the S3 module"
  type        = bool
  default     = true
}

variable "enable_ecs" {
  description = "Enable or disable the ECS module"
  type        = bool
  default     = true
}

variable "enable_lambda" {
  description = "Enable or disable the Lambda module"
  type        = bool
  default     = true
}
