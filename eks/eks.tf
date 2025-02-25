module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "iron-gold-eks"
  cluster_version = "1.30"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  eks_managed_node_groups = {
    default = {
      min_size     = 2
      max_size     = 5
      desired_size = 3

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
}


# Override the aws_cloudwatch_log_group resource
resource "aws_cloudwatch_log_group" "eks_log_group" {
  name = "/aws/eks/iron-gold-eks/cluster"

  lifecycle {
    create_before_destroy = true
  }
}