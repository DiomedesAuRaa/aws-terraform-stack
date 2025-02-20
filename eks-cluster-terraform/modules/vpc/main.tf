resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id           = aws_vpc.main.id
  cidr_block       = "10.0.1.${count.index * 16}/28"
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}
