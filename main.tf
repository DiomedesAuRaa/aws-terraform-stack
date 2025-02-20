terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "aws/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}
