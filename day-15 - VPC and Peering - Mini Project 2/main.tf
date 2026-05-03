data "aws_ami" "primary_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "secondary_amazon_linux" {
  provider    = aws.secondary
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_vpc" "primary" {
  cidr_block           = var.primary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-primary-vpc"
  })
}

resource "aws_vpc" "secondary" {
  provider             = aws.secondary
  cidr_block           = var.secondary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-secondary-vpc"
  })
}

resource "aws_subnet" "primary_public" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = var.primary_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.primary_region}a"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-primary-public-subnet"
  })
}

resource "aws_subnet" "secondary_public" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = var.secondary_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.secondary_region}a"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-secondary-public-subnet"
  })
}

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-primary-igw"
  })
}

resource "aws_internet_gateway" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-secondary-igw"
  })
}

resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.primary.id
  peer_vpc_id = aws_vpc.secondary.id
  peer_region = var.secondary_region
  auto_accept = false

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-cross-region-peer"
  })
}

resource "aws_vpc_peering_connection_accepter" "peer_accept" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-cross-region-peer-accepter"
  })
}

resource "aws_route_table" "primary_public" {
  vpc_id = aws_vpc.primary.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-primary-public-rt"
  })
}

resource "aws_route_table" "secondary_public" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-secondary-public-rt"
  })
}

resource "aws_route" "primary_internet" {
  route_table_id         = aws_route_table.primary_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary.id
}

resource "aws_route" "secondary_internet" {
  provider               = aws.secondary
  route_table_id         = aws_route_table.secondary_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.secondary.id
}

resource "aws_route" "primary_to_secondary" {
  route_table_id            = aws_route_table.primary_public.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  depends_on = [aws_vpc_peering_connection_accepter.peer_accept]
}

resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_public.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  depends_on = [aws_vpc_peering_connection_accepter.peer_accept]
}

resource "aws_route_table_association" "primary_public" {
  subnet_id      = aws_subnet.primary_public.id
  route_table_id = aws_route_table.primary_public.id
}

resource "aws_route_table_association" "secondary_public" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_public.id
  route_table_id = aws_route_table.secondary_public.id
}

resource "aws_security_group" "primary" {
  name        = "${var.project_name}-primary-sg"
  description = "Security group for primary EC2 instance"
  vpc_id      = aws_vpc.primary.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip]
  }

  ingress {
    description = "ICMP from secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  ingress {
    description = "All TCP from secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-primary-sg"
  })
}

resource "aws_security_group" "secondary" {
  provider    = aws.secondary
  name        = "${var.project_name}-secondary-sg"
  description = "Security group for secondary EC2 instance"
  vpc_id      = aws_vpc.secondary.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip]
  }

  ingress {
    description = "ICMP from primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "All TCP from primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-secondary-sg"
  })
}

resource "aws_instance" "primary" {
  ami                         = data.aws_ami.primary_amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.primary_public.id
  vpc_security_group_ids      = [aws_security_group.primary.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd

    cat > /var/www/html/index.html <<HTML
    <html>
      <head>
        <title>Primary VPC</title>
      </head>
      <body>
        <h1>Hello from Primary VPC</h1>
        <p>Region: ${var.primary_region}</p>
        <p>VPC CIDR: ${var.primary_vpc_cidr}</p>
        <p>Subnet CIDR: ${var.primary_subnet_cidr}</p>
      </body>
    </html>
    HTML
  EOF

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-primary-ec2"
  })
}

resource "aws_instance" "secondary" {
  provider                    = aws.secondary
  ami                         = data.aws_ami.secondary_amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.secondary_public.id
  vpc_security_group_ids      = [aws_security_group.secondary.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd

    cat > /var/www/html/index.html <<HTML
    <html>
      <head>
        <title>Secondary VPC</title>
      </head>
      <body>
        <h1>Hello from Secondary VPC</h1>
        <p>Region: ${var.secondary_region}</p>
        <p>VPC CIDR: ${var.secondary_vpc_cidr}</p>
        <p>Subnet CIDR: ${var.secondary_subnet_cidr}</p>
      </body>
    </html>
    HTML
  EOF

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-secondary-ec2"
  })
}