#!/bin/bash

# Define repo name
REPO_NAME="eks-cluster-terraform"

# Create directory structure
mkdir -p $REPO_NAME/{modules/{vpc,eks},environments/{dev,prod}}

# Create and populate main Terraform files
cat <<EOF > $REPO_NAME/main.tf
terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "eks/terraform.tfstate"
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

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-cluster"
}
EOF

cat <<EOF > $REPO_NAME/outputs.tf
output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  value       = module.eks.cluster_security_group_id
}
EOF

cat <<EOF > $REPO_NAME/README.md
# EKS Cluster Terraform

This Terraform project provisions an AWS EKS cluster with supporting VPC and security configurations.

## Setup

1. Ensure Terraform is installed.
2. Configure AWS credentials.
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
- \`modules/eks\` - Deploys the EKS cluster.
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

# Populate EKS module
cat <<EOF > $REPO_NAME/modules/eks/main.tf
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id
}
EOF

cat <<EOF > $REPO_NAME/modules/eks/variables.tf
variable "cluster_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_id" {}
EOF

cat <<EOF > $REPO_NAME/modules/eks/outputs.tf
output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}
EOF

# Populate environment configurations
for env in dev prod; do
  cat <<EOF > $REPO_NAME/environments/$env/main.tf
module "vpc" {
  source = "../../modules/vpc"
}

module "eks" {
  source      = "../../modules/eks"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = []
}
EOF

  cat <<EOF > $REPO_NAME/environments/$env/variables.tf
variable "cluster_name" {
  default = "$env-cluster"
}
EOF

  cat <<EOF > $REPO_NAME/environments/$env/outputs.tf
output "cluster_id" {
  value = module.eks.cluster_id
}
EOF
done

echo "Terraform project structure and configuration files created successfully!"