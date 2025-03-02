provider "aws" {
  region = var.region
}

data "aws_vpc" "existing" {
  id = "vpc-0eea538efbaee7afd"
}

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

data "aws_subnet" "subnet_a" {
  filter {
    name   = "tag:Name"
    values = ["ecs-subnet-a"]
  }
}

data "aws_subnet" "subnet_b" {
  filter {
    name   = "tag:Name"
    values = ["ecs-subnet-b"]
  }
}

# Log Group
resource "aws_cloudwatch_log_group" "mood_gif_app_log_group" {
  name              = "/ecs/mood-gif-app"
  retention_in_days = 14
}

# ECS Security Group
resource "aws_security_group" "ecs_sg" {
  vpc_id = data.aws_vpc.existing.id
  tags   = { Name = "ecs-sg" }
}

# Allow HTTPS Egress for ECR access
resource "aws_security_group_rule" "allow_https_egress" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}

# Allow inbound traffic for the app
resource "aws_security_group_rule" "allow_http_ingress" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# Fetch IAM Role
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
}

# Attach required policies to execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = data.aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_policy" "ecs_ecr_policy" {
  name        = "ecs-ecr-policy"
  description = "Allows ECS tasks to pull images from ECR"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ecr:GetAuthorizationToken"],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = ["ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"],
        Resource = "arn:aws:ecr:us-east-1:122610514415:repository/mood-gif-app"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_ecr_policy" {
  policy_arn = aws_iam_policy.ecs_ecr_policy.arn
  role       = data.aws_iam_role.ecs_task_execution_role.name
}

# ECS Task Definition
resource "aws_ecs_task_definition" "mood_gif_task" {
  family             = "mood-gif-task"
  cpu                = "256"
  memory             = "512"
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode       = "awsvpc"

  container_definitions = jsonencode([
    {
      name         = "gif-mood-generator"
      image        = "122610514415.dkr.ecr.us-east-1.amazonaws.com/mood-gif-app:latest"
      essential    = true
      portMappings = [{ containerPort = 5000, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/mood-gif-app"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      secrets = [
        {
          name      = "GIPHY_API_KEY"
          valueFrom = "arn:aws:secretsmanager:us-east-1:122610514415:secret:giphy_api_key-2gTXDG"
        }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "mood_gif_service" {
  name            = "mood-gif-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.mood_gif_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [data.aws_subnet.subnet_a.id, data.aws_subnet.subnet_b.id] # Use existing subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "gif-mood-generator"  
    container_port   = 5000
  }
}

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "alerts"
}

# CloudWatch Module
module "cloudwatch" {
  source            = "./modules/cloudwatch"
  alarm_name        = "high_log_frequency_alarm"
  threshold         = 10
  evaluation_period = 1
  period            = 60
  sns_topic_arn     = aws_sns_topic.alerts.arn
  log_group_name    = "/ecs/mood-gif-app"
}