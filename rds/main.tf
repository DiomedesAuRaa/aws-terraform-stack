provider "aws" {
  region = var.aws_region
}

# Use existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0eea538efbaee7afd"
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.existing_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "Public Subnet"
  }
}

# Create first private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "Private Subnet"
  }
}

# Create second private subnet in a different AZ
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "Private Subnet 2"
  }
}

# Data source to find the existing Internet Gateway
data "aws_internet_gateway" "existing_gw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
}

# Reference the existing Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "Main IGW"
  }

  # Use the existing IGW ID
  id = data.aws_internet_gateway.existing_gw.id
}

# Create a route table for public traffic
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.existing_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.existing_gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate public subnet with the public route table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a security group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ Change this to a more restricted range for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

# Retrieve DB password from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.db_password_secret_name
}

data "aws_secretsmanager_secret_version" "db_username" {
  secret_id = var.db_username_secret_name
}

# Create an RDS Instance
resource "aws_db_instance" "production_db" {
  identifier        = var.db_instance_identifier
  db_name           = var.db_name
  username          = data.aws_secretsmanager_secret_version.db_username.secret_string
  password          = data.aws_secretsmanager_secret_version.db_password.secret_string
  instance_class    = var.db_instance_class
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type

  backup_retention_period = 7
  multi_az                = true
  storage_encrypted       = true
  deletion_protection     = false
  publicly_accessible     = false
  # final_snapshot_identifier = "production-db-final-snapshot"
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "Production DB"
  }
}

# Create a subnet group for RDS across two AZs
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "RDS Subnet Group"
  }
}
