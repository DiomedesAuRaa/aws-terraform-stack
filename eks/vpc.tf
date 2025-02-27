module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0" 
  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.0.105.0/24", "10.0.106.0/24", "10.0.107.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  enable_dns_hostnames = true
}
