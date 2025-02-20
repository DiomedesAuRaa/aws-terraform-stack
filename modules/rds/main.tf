resource "aws_db_instance" "db" {
  identifier = "my-rds-instance"
  engine     = "postgres"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  publicly_accessible = false
}
