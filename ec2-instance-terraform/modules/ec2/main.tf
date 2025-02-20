resource "aws_instance" "web" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (change as needed)
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  security_groups        = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port  
