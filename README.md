# AWS Infrastructure with Terraform

This repository contains Terraform configurations for deploying both an **EKS cluster** and an **EC2 instance** on AWS using modular infrastructure.

## Repository Structure

```
.
├── eks/          # Terraform configuration for EKS cluster
├── ec2/          # Terraform configuration for EC2 instance
├── modules/      # Shared Terraform modules
├── environments/ # Environment-specific configurations
└── README.md
```

## Prerequisites
- Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Configure your AWS credentials (see instructions in each subdirectory's README)
- Ensure you have the necessary AWS permissions to create EKS and EC2 resources

## Deploying EKS Cluster
1. Navigate to the EKS directory:
   ```sh
   cd eks
   ```
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```
4. Once complete, Terraform will output the cluster name and other details.

## Deploying EC2 Instance
1. Navigate to the EC2 directory:
   ```sh
   cd ec2
   ```
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```
4. The instance ID and public IP will be displayed upon successful deployment.

## Cleaning Up Resources
To destroy resources when no longer needed:
```sh
terraform destroy -auto-approve
```
Run this command from either `eks/` or `ec2/` depending on what you want to remove.

---

For more details on each module, refer to their respective README files inside `eks/` and `ec2/`.

