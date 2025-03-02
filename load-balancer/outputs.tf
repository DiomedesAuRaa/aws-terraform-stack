output "alb_arn" {
  value = aws_lb.ecs_alb.arn
}
output "public_subnet_ids" {
  value = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
}
output "alb_zone_id" {
  value = aws_lb.ecs_alb.zone_id
}