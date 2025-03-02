terraform {
  backend "s3" {
    bucket         = "diomedesauraa-terraform-state"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}