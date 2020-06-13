resource "aws_vpc" "fargate_run_task" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "fargate_run_task"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.fargate_run_task.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.fargate_run_task.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_route_table"
  }
}

resource "aws_subnet" "public_0" {
    vpc_id = aws_vpc.fargate_run_task.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"
    tags = {
      Name = "subnet-public-1a"
    }
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public_route_table.id
    gateway_id = aws_internet_gateway.igw.id
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public-association" {
    subnet_id = aws_subnet.public_0.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_0" {
  vpc_id                  = aws_vpc.fargate_run_task.id
  cidr_block              = "10.0.65.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private_0" {
  vpc_id                  = aws_vpc.fargate_run_task.id
}

resource "aws_route_table_association" "private_0" {
  subnet_id = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.fargate_run_task.id
  cidr_block              = "10.0.66.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private_1" {
  vpc_id                  = aws_vpc.fargate_run_task.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  vpc_id      = aws_vpc.fargate_run_task.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
