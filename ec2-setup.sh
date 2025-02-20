#!/bin/bash

# Define repo name
REPO_NAME="ec2-instance-terraform"

# Create directory structure
mkdir -p $REPO_NAME/{modules/{vpc,ec2},environments/{dev,prod}}

# Create and populate main Terraform files
cat <<EOF > $REPO_NAME/main.tf
terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
EOF

cat <<EOF > $REPO_NAME/variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
EOF

cat <<EOF > $REPO_NAME/outputs.tf
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.public_ip
}
EOF

cat <<EOF > $REPO_NAME/README.md
# EC2 Instance Terraform

This Terraform project provisions an AWS EC2 instance with a VPC and security configurations.

## Setup

1. Ensure Terraform is installed.
2. Configure AWS credentials.

### Options for AWS Credentials
Terraform requires AWS credentials to deploy resources. Choose one of the following methods:

#### **Option 1: AWS CLI Credentials (Recommended for Local Use)**
If you have the AWS CLI installed, you can configure credentials with:
\`\`\`sh
aws configure
\`\`\`
This stores credentials in \`~/.aws/credentials\` and \`~/.aws/config\`, which Terraform will use automatically.

#### **Option 2: Environment Variables (Good for CI/CD)**
Set the credentials as environment variables:
\`\`\`sh
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
\`\`\`

#### **Option 3: AWS IAM Roles with SSO (Best for Teams)**
If using AWS SSO, authenticate with:
\`\`\`sh
aws sso login
export AWS_PROFILE=my-sso-profile
terraform apply
\`\`\`
This assumes your SSO profile is configured in \`~/.aws/config\`.

#### **Option 4: IAM Roles for EC2**
If Terraform runs on an EC2 instance, it can assume an IAM role attached to the instance. Terraform will automatically inherit these permissions.

#### **Option 5: AWS Named Profiles**
If using multiple AWS accounts, specify a profile:
\`\`\`sh
export AWS_PROFILE=my-profile
terraform apply
\`\`\`
Or configure it in Terraform:
\`\`\`hcl
provider "aws" {
  region  = "us-east-1"
  profile = "my-profile"
}
\`\`\`

3. Initialize Terraform:
   \`\`\`sh
   terraform init
   \`\`\`
4. Apply the configuration:
   \`\`\`sh
   terraform apply -auto-approve
   \`\`\`

## Structure
- \`modules/vpc\` - Configures the VPC.
- \`modules/ec2\` - Deploys the EC2 instance.
- \`environments/dev\` and \`environments/prod\` - Environment-specific configurations.
EOF

# Populate VPC module
cat <<EOF > $REPO_NAME/modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id           = aws_vpc.main.id
  cidr_block       = "10.0.1.\${count.index * 16}/28"
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}
EOF

cat <<EOF > $REPO_NAME/modules/vpc/variables.tf
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
EOF

cat <<EOF > $REPO_NAME/modules/vpc/outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}
EOF

# Populate EC2 module
cat <<EOF > $REPO_NAME/modules/ec2/main.tf
resource "aws_instance" "web" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (change as needed)
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  security_groups        = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port  
