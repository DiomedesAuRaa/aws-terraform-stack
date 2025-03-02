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
resource "aws_security_group" "alb_sg" {
  name        = "ecs-alb-sg"
  description = "Allow HTTP traffic on port 5000"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Publicly accessible
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer (ALB)
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  # Use directly created subnet IDs (not data source lookups)
  subnets = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]
}

# Target Group for ECS Services
resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Required for Fargate services

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

# ALB Listener for Port 5000
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}