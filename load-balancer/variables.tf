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