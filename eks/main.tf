# Create a new Security Group
resource "aws_security_group" "eks_sg" {
  name_prefix = "eks-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-sg"
  }
}

# EKS Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.0"
  cluster_name    = "iron-gold-eks"
  cluster_version = "1.31"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  # Pass the new Security Group to the EKS module
  cluster_security_group_id = aws_security_group.eks_sg.id

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