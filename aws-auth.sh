#!/bin/bash

# Variables
IAM_USER_NAME="terraform-user"
TF_VARS_FILE="terraform.tfvars"

# Function to check AWS credentials
check_aws_credentials() {
    echo "Authenticating to AWS..."
    aws sts get-caller-identity > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: Unable to locate AWS credentials. Please run 'aws configure' to set up your credentials."
        exit 1
    fi
}

# Check AWS credentials
check_aws_credentials

# Check if the IAM user exists
echo "Checking if IAM user $IAM_USER_NAME exists..."
USER_EXISTS=$(aws iam get-user --user-name $IAM_USER_NAME 2>&1)

if [[ $USER_EXISTS == *"NoSuchEntity"* ]]; then
    echo "Error: IAM user $IAM_USER_NAME does not exist. Please create it manually or update the script."
    exit 1
else
    echo "IAM user $IAM_USER_NAME exists."
fi

# Check if the user already has 2 access keys
KEY_COUNT=$(aws iam list-access-keys --user-name $IAM_USER_NAME --query 'AccessKeyMetadata[*].AccessKeyId' --output text | wc -w)

if [ $KEY_COUNT -ge 2 ]; then
    echo "Error: IAM user $IAM_USER_NAME already has 2 access keys. Delete one to create a new key."
    echo "List of existing access keys:"
    aws iam list-access-keys --user-name $IAM_USER_NAME
    echo "To delete an access key, run:"
    echo "aws iam delete-access-key --user-name $IAM_USER_NAME --access-key-id ACCESS_KEY_ID"
    exit 1
fi

# Create a new access key and secret key for the IAM user
echo "Creating a new access key and secret key for IAM user $IAM_USER_NAME..."
CREDENTIALS=$(aws iam create-access-key --user-name $IAM_USER_NAME --output json)
if [ $? -ne 0 ]; then
    echo "Error: Failed to create access key for IAM user."
    exit 1
fi

# Extract AccessKeyId and SecretAccessKey from the JSON output
ACCESS_KEY=$(echo $CREDENTIALS | jq -r '.AccessKey.AccessKeyId')
SECRET_KEY=$(echo $CREDENTIALS | jq -r '.AccessKey.SecretAccessKey')

# Output the credentials to a terraform.tfvars file
echo "Writing credentials to $TF_VARS_FILE..."
cat > $TF_VARS_FILE <<EOF
aws_access_key = "$ACCESS_KEY"
aws_secret_key = "$SECRET_KEY"
region         = "us-east-1"
EOF

echo "Script completed successfully."
echo "Credentials have been written to $TF_VARS_FILE."