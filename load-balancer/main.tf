provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "existing" {
  id = var.vpc_id
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "ecs-subnet-a" }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags                    = { Name = "ecs-subnet-b" }
}

# Security Group for ALB
data "aws_security_group" "alb_sg" {
  name = "ecs-alb-sg"
}

# Application Load Balancer (ALB)
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.alb_sg.id]


  # Use directly created subnet IDs (not data source lookups)
  subnets = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]
}

data "aws_lb_target_group" "ecs_tg" {
  name = "ecs-tg"
}
# ALB Listener for Port 5000
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.ecs_tg.arn
  }
}
