variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
  description = "The CIDR block for the second private subnet"
  type        = string
  default     = "10.0.3.0/24" # Define this CIDR block as needed
}

variable "db_instance_identifier" {
  description = "The name of the DB instance"
  type        = string
  default     = "production-db"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "productiondb"
}

variable "db_instance_class" {
  description = "The instance type for the DB instance"
  type        = string
  default     = "db.m5.large"
}

variable "db_engine" {
  description = "The engine for the DB instance"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "The engine version for the DB instance"
  type        = string
  default     = "13.20"
}

variable "db_allocated_storage" {
  description = "The allocated storage (in GB) for the DB instance"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "The storage type for the DB instance"
  type        = string
  default     = "gp2"
}

variable "db_username_secret_name" {
  description = "The name of the AWS Secrets Manager secret storing the DB password"
  type        = string
  default     = "rds-username"
}

variable "db_password_secret_name" {
  description = "The name of the AWS Secrets Manager secret storing the DB password"
  type        = string
  default     = "rds-password"
}
