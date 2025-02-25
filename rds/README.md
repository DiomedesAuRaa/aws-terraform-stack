# Terraform AWS RDS Deployment

## Overview
This Terraform configuration sets up a **production-ready AWS RDS instance** with the following features:
- **AWS Secrets Manager** stores the database username and password securely.
- **Private VPC and security groups** ensure restricted access.
- **Multi-AZ deployment** for high availability.
- **Automated backups are disabled (edit if you want these)** and encryption for security.
- **Terraform variables** allow easy customization.

## Prerequisites
Before running Terraform, ensure you have:
- **Terraform** installed ([Download Terraform](https://developer.hashicorp.com/terraform/downloads))
- **AWS CLI** installed ([Download AWS CLI](https://aws.amazon.com/cli/))
- **AWS credentials** configured (via `aws configure`, environment variables, or by specifying them in a `terraform.tfvars` file for Terraform to use during execution)
- **AWS IAM permissions** to manage RDS, VPC, and Secrets Manager

## Setup Instructions

### 1️⃣ Clone the Repository
```bash
git clone <your-repo-url>
cd <your-project-directory>
```

### 2️⃣ Initialize Terraform
```bash
terraform init
```

### 3️⃣ Create AWS Secrets Manager Secrets for the RDS Username and Password
```bash
aws secretsmanager create-secret \
    --name rds-username \
    --secret-string "dbadmin"

aws secretsmanager create-secret \
    --name rds-password \
    --secret-string "super-secure-password"
```

### 4️⃣ Configure Terraform Variables
Edit the `terraform.tfvars` file and customize as needed:
```hcl
db_instance_identifier = "my-production-db"
db_name                = "mydatabase"
db_instance_class      = "db.t3.medium"
db_engine             = "postgres"
db_engine_version      = "14.5"
db_allocated_storage   = 20
db_storage_type        = "gp2"
db_username_secret_name = "rds-username"
db_password_secret_name = "rds-password"
```

### 5️⃣ Apply the Terraform Configuration
```bash
terraform apply -auto-approve
```
This will deploy the RDS instance with the specified settings.

### 6️⃣ Verify the Deployment
Once Terraform completes, check the RDS instance:
```bash
aws rds describe-db-instances --query "DBInstances[*].{ID:DBInstanceIdentifier,Status:DBInstanceStatus}"
```

## Outputs
After applying, Terraform will output important details:
```bash
Outputs:
rds_endpoint = "my-production-db.xxxxxxxxxxxx.us-west-2.rds.amazonaws.com"
```
Use this **`rds_endpoint`** to connect your application to the database.

## Cleanup
To **destroy** all resources created:
```bash
terraform destroy -auto-approve
```

## Security Best Practices
- Use **IAM roles** instead of storing credentials in Terraform files.
- Restrict **public access** to the RDS instance.
- Enable **AWS CloudWatch logs** for monitoring.
- Regularly **rotate credentials** stored in AWS Secrets Manager.

## Troubleshooting
If you encounter issues:
1. **Check Terraform logs:** `terraform apply -auto-approve --debug`
2. **Verify AWS credentials:** `aws sts get-caller-identity`
3. **Manually retrieve the secrets:**
   ```bash
   aws secretsmanager get-secret-value --secret-id rds-username
   aws secretsmanager get-secret-value --secret-id rds-password
   ```
4. **Ensure RDS is accessible:**
   ```bash
   nc -zv <rds-endpoint> 5432
   ```

## Next Steps
✅ Integrate RDS with **Amazon RDS Proxy** for connection pooling.  
✅ Add **CloudWatch monitoring** for performance tracking.  
✅ Implement **automatic failover** with Multi-AZ replication.  

---