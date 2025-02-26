output "ecs_cluster_id" {
  description = "The ID of the ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.mood_gif_service.name
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition."
  value       = aws_ecs_task_definition.mood_gif_task.arn
}