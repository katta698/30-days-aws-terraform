data "aws_vpc" "shared" {
  filter {
    name   = "tag:Name"
    values = ["shared-network-vpc"]
  }
}

data "aws_subnet" "shared" {
  filter {
    name   = "tag:Name"
    values = ["shared-primary-subnet"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.shared.id]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "day13_sg" {
  name        = "day13-data-source-sg"
  description = "Security group for Day 13 EC2 instance"
  vpc_id      = data.aws_vpc.shared.id

  ingress {
    description = "Allow SSH for demo"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["12.50.200.114/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "day13-data-source-sg"
    Project = "Day13-DataSources"
  }
}

resource "aws_instance" "day13_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.shared.id
  vpc_security_group_ids      = [aws_security_group.day13_sg.id]
  associate_public_ip_address = true

  tags = {
    Name    = "day13-instance"
    Project = "Day13-DataSources"
  }
}