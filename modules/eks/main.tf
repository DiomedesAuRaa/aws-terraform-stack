resource "aws_eks_cluster" "eks" {
  name     = "my-eks-cluster"
  role_arn = "arn:aws:iam::123456789012:role/EKSRole"

  vpc_config {
    subnet_ids = ["subnet-123456", "subnet-654321"]
  }
}
