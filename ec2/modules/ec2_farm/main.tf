data "aws_subnets" "supported_subnets" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"] # Replace with AZs where your instance type is supported
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id] # Ensure the subnets belong to the correct VPC
  }
}

# Filter the public subnets to include only those in supported AZs
locals {
  supported_public_subnets = [
    for subnet in var.public_subnets : subnet
    if contains(data.aws_subnets.supported_subnets.ids, subnet)
  ]
}

resource "aws_launch_template" "ec2_template" {
  name_prefix   = "ec2-farm"
  image_id      = "ami-0062355a529d6089c" # Replace with your desired AMI ID
  instance_type = var.instance_type       # Use the instance type passed from the root module
  key_name      = "my-key"                # Replace with your key pair name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id] # Use the security group ID passed from the root module
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = data.aws_subnets.supported_subnets.ids

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }
}

# Output
output "asg_name" {
  value = aws_autoscaling_group.ec2_asg.name
}