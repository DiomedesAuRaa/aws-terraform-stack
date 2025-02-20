output "eks_cluster_name" {
  value = var.enable_eks ? module.eks[0].cluster_name : "EKS module disabled"
}

output "ec2_public_ip" {
  value = var.enable_ec2 ? module.ec2[0].public_ip : "EC2 module disabled"
}

output "rds_instance" {
  value = var.enable_rds ? module.rds[0].instance_name : "RDS module disabled"
}

output "s3_bucket" {
  value = var.enable_s3 ? module.s3[0].bucket_name : "S3 module disabled"
}

output "ecs_cluster_name" {
  value = var.enable_ecs ? module.ecs[0].cluster_name : "ECS module disabled"
}

output "lambda_function_arn" {
  value = var.enable_lambda ? module.lambda[0].function_arn : "Lambda module disabled"
}
