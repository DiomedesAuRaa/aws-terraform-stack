# Terraform GitHub Workflows for AWS Environments

This repository contains GitHub Actions workflows to apply and destroy infrastructure for **RDS**, **EC2**, **ECS** and **EKS** environments using Terraform. Below are the workflow files included for each environment:

## Workflow Files

### RDS Environment Workflows

- **`terraform-apply-rds.yml`**: This workflow applies the Terraform configuration to create or update the AWS RDS environment.
- **`terraform-destroy-rds.yml`**: This workflow destroys the AWS RDS environment managed by Terraform.

### EC2 Environment Workflows

- **`terraform-apply-ec2.yml`**: This workflow applies the Terraform configuration to create or update the AWS EC2 environment.
- **`terraform-destroy-ec2.yml`**: This workflow destroys the AWS EC2 environment managed by Terraform.

### EKS Environment Workflows

- **`terraform-apply-eks.yml`**: This workflow applies the Terraform configuration to create or update the AWS EKS environment.
- **`terraform-destroy-eks.yml`**: This workflow destroys the AWS EKS environment managed by Terraform.

### ECS Environment Workflows

- **`terraform-apply-ecs.yml`**: This workflow applies the Terraform configuration to create or update the AWS ECS environment.
- **`terraform-destroy-ecs.yml`**: This workflow destroys the AWS ECS environment managed by Terraform.

### S3 Environment Workflows

- **`terraform-apply-s3.yml`**: This workflow applies the Terraform configuration to create or update the AWS S3 environment.
- **`terraform-destroy-s3.yml`**: This workflow destroys the AWS S3 environment managed by Terraform.