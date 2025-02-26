variable "aws_region" {
  description = "AWS region"
  type        = string
  default     =  "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
  default     =  "vpc-0eea538efbaee7afd"
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
  default     = ["subnet-0c91423b4b0ec6abe", "subnet-0e7bb73e264a6aa17"]
}