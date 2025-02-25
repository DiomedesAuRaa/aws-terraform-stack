provider "aws" {
  region = "us-east-1"
}

module "network" {
  source        = "./modules/network"
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "ec2_farm" {
  source            = "./modules/ec2_farm"
  vpc_id            = module.network.vpc_id
  public_subnets    = module.network.public_subnets
  private_subnets   = module.network.private_subnets
  security_group_id = module.security.ec2_sg_id
  instance_type     = "t3.medium"
  min_size          = 2
  max_size          = 5
  desired_capacity  = 3
}