resource "aws_vpc" "shared_vpc" {
  cidr_block           = "10.13.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "shared-network-vpc"
    Environment = "dev"
    Project     = "Day13-DataSources"
  }
}

resource "aws_subnet" "shared_subnet" {
  vpc_id                  = aws_vpc.shared_vpc.id
  cidr_block              = "10.13.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "shared-primary-subnet"
    Environment = "dev"
    Project     = "Day13-DataSources"
  }
}