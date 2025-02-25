# EKS Cluster Setup with Terraform

This repository contains Terraform configuration files to deploy a production-ready Amazon EKS cluster.

## Prerequisites

Before applying the Terraform configurations, ensure you have the following installed:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)

## Setting Up AWS Credentials

Terraform requires AWS credentials for authentication. Set them up using one of the following methods:

### **Method 1: Environment Variables**

Run the following commands to set AWS credentials as environment variables:

```sh
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```

### **Method 2: AWS CLI Configuration**

Use the AWS CLI to configure your credentials:

```sh
aws configure
```

Enter your AWS Access Key, Secret Access Key, region, and output format when prompted.

## Initializing and Deploying the EKS Cluster

### **Initialize Terraform**

Before running Terraform, initialize the project:

```sh
terraform init
```

### **Validate the Configuration**

Ensure the configuration files are correct:

```sh
terraform validate
```

### **Apply Terraform Configuration**

You can apply the configuration using one of the following methods:

#### **Without a Variable File**

```sh
terraform apply -auto-approve
```

#### **With a Variable File (`terraform.tfvars`)**

Create a `terraform.tfvars` file with your AWS credentials:

```hcl
region = "us-east-1"
aws_access_key = "your-access-key"
aws_secret_key = "your-secret-key"
```

Then apply the Terraform configuration:

```sh
terraform apply -var-file=terraform.tfvars -auto-approve
```

## Destroying the Cluster

To delete the EKS cluster and all associated resources, run:

```sh
terraform destroy -auto-approve
```

## Notes

- Ensure your AWS IAM user has the necessary permissions to create EKS resources.
- Use an S3 backend for remote state management in a production environment.

---

## TODO

- right now the state locking is a bit jacked up, so i have lock set to false. Which isnt great, at scale this would be bad. 