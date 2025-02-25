output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.production_db.endpoint
}

output "rds_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.production_db.arn
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.production_db.id
}
