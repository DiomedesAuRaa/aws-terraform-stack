data "aws_subnets" "supported_subnets" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

locals {
  supported_public_subnets = [
    for subnet in var.public_subnets : subnet
    if contains(data.aws_subnets.supported_subnets.ids, subnet)
  ]
}

resource "aws_launch_template" "ec2_template" {
  name_prefix   = "ec2-farm"
  image_id      = "ami-0062355a529d6089c" 
  instance_type = var.instance_type       
  key_name      = "my-key"              

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = local.supported_public_subnets

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }
}

# Output
output "asg_name" {
  value = aws_autoscaling_group.ec2_asg.name
}