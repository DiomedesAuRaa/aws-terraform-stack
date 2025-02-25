# Declare the instance_type variable
variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t3.medium"  # Optional: Provide a default value
}

# Data source to fetch subnets in supported AZs
data "aws_subnets" "supported_subnets" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]  # Replace with AZs where your instance type is supported
  }
}

# Data source to fetch the VPC ID of the subnets
data "aws_subnet" "example" {
  id = data.aws_subnets.supported_subnets.ids[0]  # Use the first subnet to get the VPC ID
}

# Security Group (ensure it is in the same VPC as the subnets)
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-farm-sg"
  vpc_id      = data.aws_subnet.example.vpc_id

  # Add your ingress/egress rules here
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Template
resource "aws_launch_template" "ec2_template" {
  name_prefix   = "ec2-farm"
  image_id      = "ami-0062355a529d6089c"  # Replace with your desired AMI ID
  instance_type = var.instance_type  # Use the declared variable
  key_name      = "my-key"  # Replace with your key pair name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]  # Use the security group created above
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = data.aws_subnets.supported_subnets.ids  # Use dynamically filtered subnets

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }
}

# Output
output "asg_name" {
  value = aws_autoscaling_group.ec2_asg.name
}