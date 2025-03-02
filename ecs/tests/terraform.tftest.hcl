# terraform.tftest.hcl

variables {
  region            = "us-east-1"
  ecs_cluster_name  = "test-ecs-cluster"
  target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/test-tg/1234567890123456"
}

# Test for AWS VPC Data Source
run "validate_vpc_data_source" {
  command = plan

  assert {
    condition     = data.aws_vpc.existing.id == "vpc-0eea538efbaee7afd"
    error_message = "VPC ID does not match the expected value"
  }
}

# Test for ECS AMI Data Source
run "validate_ecs_ami_data_source" {
  command = plan

  assert {
    condition     = data.aws_ssm_parameter.ecs_ami.name == "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
    error_message = "ECS AMI SSM parameter name does not match the expected value"
  }
}

# Test for Subnet Data Sources
run "validate_subnet_data_sources" {
  command = plan

  assert {
    condition     = data.aws_subnet.subnet_a.tags["Name"] == "ecs-subnet-a"
    error_message = "Subnet A name does not match the expected value"
  }

  assert {
    condition     = data.aws_subnet.subnet_b.tags["Name"] == "ecs-subnet-b"
    error_message = "Subnet B name does not match the expected value"
  }
}

# Test for CloudWatch Log Group
run "validate_cloudwatch_log_group" {
  command = plan

  assert {
    condition     = aws_cloudwatch_log_group.mood_gif_app_log_group.retention_in_days == 14
    error_message = "CloudWatch Log Group retention period does not match the expected value"
  }
}

# Test for ECS Security Group Rules
run "validate_ecs_security_group_rules" {
  command = plan

  assert {
    condition     = aws_security_group_rule.allow_https_egress.from_port == 443
    error_message = "HTTPS egress rule from_port does not match the expected value"
  }

  assert {
    condition     = aws_security_group_rule.allow_http_ingress.to_port == 5000
    error_message = "HTTP ingress rule to_port does not match the expected value"
  }
}

# Test for ECS Cluster
run "validate_ecs_cluster" {
  command = plan

  assert {
    condition     = aws_ecs_cluster.ecs_cluster.name == var.ecs_cluster_name
    error_message = "ECS Cluster name does not match the expected value"
  }
}

# Test for ECS Task Definition
run "validate_ecs_task_definition" {
  command = plan

  assert {
    condition     = aws_ecs_task_definition.mood_gif_task.family == "mood-gif-task"
    error_message = "ECS Task Definition family does not match the expected value"
  }

  assert {
    condition     = aws_ecs_task_definition.mood_gif_task.network_mode == "awsvpc"
    error_message = "ECS Task Definition network mode does not match the expected value"
  }
}

# Test for ECS Service
run "validate_ecs_service" {
  command = plan

  assert {
    condition     = aws_ecs_service.mood_gif_service.launch_type == "FARGATE"
    error_message = "ECS Service launch type does not match the expected value"
  }

  assert {
    condition     = length(aws_ecs_service.mood_gif_service.network_configuration[0].subnets) == 2
    error_message = "ECS Service subnets count does not match the expected value"
  }
}

# Test for SNS Topic
run "validate_sns_topic" {
  command = plan

  assert {
    condition     = aws_sns_topic.alerts.name == "alerts"
    error_message = "SNS Topic name does not match the expected value"
  }
}

# Test for CloudWatch Module
run "validate_cloudwatch_module" {
  command = plan

  assert {
    condition     = module.cloudwatch.alarm_name == "high_log_frequency_alarm"
    error_message = "CloudWatch alarm name does not match the expected value"
  }

  assert {
    condition     = module.cloudwatch.log_group_name == "/ecs/mood-gif-app"
    error_message = "CloudWatch log group name does not match the expected value"
  }
}