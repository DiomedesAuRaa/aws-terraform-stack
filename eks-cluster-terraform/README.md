# EKS Cluster Terraform

This Terraform project provisions an AWS EKS cluster with supporting VPC and security configurations.

## Setup

1. Ensure Terraform is installed.
2. Configure AWS credentials.

### Options for AWS Credentials
Terraform requires AWS credentials to deploy resources. Choose one of the following methods:

#### **Option 1: AWS CLI Credentials (Recommended for Local Use)**
If you have the AWS CLI installed, you can configure credentials with:
```sh
aws configure
```
This stores credentials in `~/.aws/credentials` and `~/.aws/config`, which Terraform will use automatically.

#### **Option 2: Environment Variables (Good for CI/CD)**
Set the credentials as environment variables:
```sh
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

#### **Option 3: AWS IAM Roles with SSO (Best for Teams)**
If using AWS SSO, authenticate with:
```sh
aws sso login
export AWS_PROFILE=my-sso-profile
terraform apply
```
This assumes your SSO profile is configured in `~/.aws/config`.

#### **Option 4: IAM Roles for EC2 or EKS**
If Terraform runs on an EC2 instance or inside an EKS pod, it can assume an IAM role attached to the instance. Terraform will automatically inherit these permissions.

#### **Option 5: AWS Named Profiles**
If using multiple AWS accounts, specify a profile:
```sh
export AWS_PROFILE=my-profile
terraform apply
```
Or configure it in Terraform:
```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "my-profile"
}
```

3. Initialize Terraform:
   ```sh
   terraform init
   ```
4. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```

## Structure
- `modules/vpc` - Configures the VPC.
- `modules/eks` - Deploys the EKS cluster.
- `environments/dev` and `environments/prod` - Environment-specific configurations.