resource "aws_vpc" "cluster" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "cluster-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.cluster.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "cluster" {
  vpc_id = aws_vpc.cluster.id
  
  tags = {
    Name = "cluster-igw"
  }
}   
