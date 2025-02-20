variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = "vpc-123456"
}

variable "ecs_cluster_name" {
  default = "my-ecs-cluster"
}

variable "lambda_function_name" {
  default = "my-lambda-function"
}

variable "enable_eks" {
  default = true
}

variable "enable_ec2" {
  default = true
}

variable "enable_rds" {
  default = true
}

variable "enable_s3" {
  default = true
}

variable "enable_ecs" {
  default = true
}

variable "enable_lambda" {
  default = true
}
