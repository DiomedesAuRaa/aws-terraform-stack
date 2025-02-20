# AWS Terraform Deployment

This repository contains Terraform configurations for deploying:

- Amazon EKS (Kubernetes)
- Amazon EC2 (Virtual Machines)
- Amazon RDS (Databases)
- Amazon S3 (Storage)
- Amazon ECS (Elastic Container Service)
- AWS Lambda (Serverless Functions)

## Prerequisites
- Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Install [AWS CLI](https://aws.amazon.com/cli/)
- Configure AWS credentials:
  ```sh
  aws configure
  ```

## Deploying All Services
1. Navigate to the environment (`dev` or `prod`):
   ```sh
   cd environments/dev
   ```
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```
4. The output will display service details.

## Selective Module Deployment
To enable or disable specific modules, pass the appropriate variables. For example, to only deploy EKS and S3:
```sh
terraform apply \
  -var="enable_eks=true" \
  -var="enable_ec2=false" \
  -var="enable_rds=false" \
  -var="enable_s3=true" \
  -var="enable_ecs=false" \
  -var="enable_lambda=false"
```

## Destroying Resources
```sh
terraform destroy -auto-approve
```
Run this in the environment directory.
