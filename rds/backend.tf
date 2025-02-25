terraform {
  backend "s3" {
    bucket         = "diomedesauraa-terraform-state"
    key            = "rds/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}