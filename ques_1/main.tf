provider "aws" {
  region = "us-east-1"
}


locals {
 
  name_prefix = "Aayush_Tiwari" 
  
  vpc_cidr     = "10.0.0.0/16"
  pub_sub_1_cidr = "10.0.1.0/24"
  pub_sub_2_cidr = "10.0.2.0/24"
  pvt_sub_1_cidr = "10.0.3.0/24"
  pvt_sub_2_cidr = "10.0.4.0/24"
}


resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}_VPC"
  }
}


resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.pub_sub_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}_Public_Subnet_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.pub_sub_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}_Public_Subnet_2"
  }
}


resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.pvt_sub_1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "${local.name_prefix}_Private_Subnet_1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.pvt_sub_2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "${local.name_prefix}_Private_Subnet_2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}_IGW"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  
  tags = {
    Name = "${local.name_prefix}_NAT_EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${local.name_prefix}_NAT_Gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

# --- ROUTE TABLES ---

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name_prefix}_Public_RT"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${local.name_prefix}_Private_RT"
  }
}

# --- ROUTE TABLE ASSOCIATIONS ---
resource "aws_route_table_association" "pub_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pvt_1_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "pvt_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}
