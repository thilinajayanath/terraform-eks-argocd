resource "aws_vpc" "eks" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.eks.id
  availability_zone       = "eu-central-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.eks.id
  availability_zone       = "eu-central-1a"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.eks.id
  availability_zone       = "eu-central-1b"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "eks-main"
  }
}

resource "aws_route" "igw" {
  route_table_id         = aws_vpc.eks.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


resource "aws_eip" "ng" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ng" {
  allocation_id = aws_eip.ng.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "private"
  }
}

resource "aws_route" "ng" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ng.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
