# Terraform S3 Bucket Configuration

This repository contains Terraform code to create an S3 bucket with the following features:
- **Not publicly accessible**
- **Encryption at rest enabled**
- **Automated tests** to verify the bucket configuration

---

## Prerequisites

1. **Terraform**: Ensure you have Terraform installed. For automated tests, you need **Terraform 1.6.0 or later**.
   - Download Terraform: [https://www.terraform.io/downloads](https://www.terraform.io/downloads)
   - Check your Terraform version:
     ```bash
     terraform version
     ```

2. **AWS CLI**: Ensure you have the AWS CLI configured with the necessary permissions to create and manage S3 buckets.
   - Install AWS CLI: [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/)
   - Configure AWS CLI:
     ```bash
     aws configure
     ```

---

## Repository Structure

```
.
├── s3.tf                # Terraform configuration for the S3 bucket
├── outputs.tf             # Outputs for bucket name and configuration
├── tests/                 # Directory for automated tests
│   └── bucket_test.tf     # Terraform test file (requires Terraform 1.6.0+)
├── backend.tf             # Backend config for state storage
└── README.md              # This file
```

---

## Usage

### 1. **Create the S3 Bucket**

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Validate the configuration:
   ```bash
   terraform validate
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

   This will create an S3 bucket with:
   - **Private access** (no public access)
   - **Encryption at rest** enabled using AES256
   - **Public access block** settings configured

---

### 2. **Run Automated Tests**

#### **Option A: Using Terraform Tests (Requires Terraform 1.6.0+)**
1. Run the tests:
   ```bash
   terraform test
   ```

   The tests will verify:
   - The bucket exists.
   - The bucket is not publicly accessible.
   - Encryption at rest is enabled.

---

### 2. **Verify Manually**

1. Check the bucket name in the Terraform outputs:
   ```bash
   terraform output bucket_name
   ```

2. Use the AWS CLI to verify the bucket configuration:
   ```bash
   # Check if the bucket exists
   aws s3api head-bucket --bucket <bucket_name>

   # Verify encryption at rest
   aws s3api get-bucket-encryption --bucket <bucket_name>

   # Verify public access block settings
   aws s3api get-public-access-block --bucket <bucket_name>
   ```

---

## Configuration Details

### **S3 Bucket Configuration**
- **Bucket Name**: Unique name provided in `main.tf`.
- **Access Control**: Set to `private` to prevent public access.
- **Encryption**: AES256 server-side encryption is enabled.
- **Public Access Block**: All public access is blocked.

### **Automated Tests**
- **Terraform Tests**: Written using the `run` block (requires Terraform 1.6.0+).

---

## Requirements

- **Terraform Version**: 1.6.0 or later for Terraform tests.
- **AWS Permissions**: Ensure your AWS credentials have permissions to create and manage S3 buckets.

---

## Cleanup

To delete the S3 bucket and other resources:
```bash
terraform destroy
```

# TODO
- I'm currently using a bunch of depracted modules that need to be upgraded. 
- Also I have locks off cause this isn't an important bucket, but that should get added. 
---