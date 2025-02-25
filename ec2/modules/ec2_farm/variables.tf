variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "security_group_id" {}
variable "instance_type" {}
variable "min_size" { default = 2 }
variable "max_size" { default = 5 }
variable "desired_capacity" { default = 3 }
