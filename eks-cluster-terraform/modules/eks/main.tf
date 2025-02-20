module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id
}
