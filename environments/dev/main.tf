module "eks" {
  count  = var.enable_eks ? 1 : 0
  source = "../../modules/eks"
  region = var.region
}

module "ec2" {
  count  = var.enable_ec2 ? 1 : 0
  source = "../../modules/ec2"
  region = var.region
  vpc_id = var.vpc_id
}

module "rds" {
  count  = var.enable_rds ? 1 : 0
  source = "../../modules/rds"
  region = var.region
}

module "s3" {
  count  = var.enable_s3 ? 1 : 0
  source = "../../modules/s3"
  region = var.region
}

module "ecs" {
  count  = var.enable_ecs ? 1 : 0
  source = "../../modules/ecs"
  region = var.region
  ecs_cluster_name = var.ecs_cluster_name
}

module "lambda" {
  count  = var.enable_lambda ? 1 : 0
  source = "../../modules/lambda"
  region = var.region
  lambda_function_name = var.lambda_function_name
}
