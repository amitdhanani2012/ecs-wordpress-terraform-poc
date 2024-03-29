# VPC

resource "aws_vpc" "default" {
  cidr_block         = var.vpc_cidr_block
  enable_dns_support = true
  tags = {
    Name = "wp-pvc-tf"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "wp-igw-tf"
  }
}


# Subnets

resource "aws_subnet" "wp-public-tf" {
  count             = length(var.public_subnet_cidr_block)
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "wp-public-tf"
  }
}

resource "aws_subnet" "wp-private-tf" {
  count             = length(var.private_subnet_cidr_block)
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "wp-private-tf"
  }
}

# Route Tables

resource "aws_route_table" "wp-rt-public-tf" {
  count  = length(aws_subnet.wp-public-tf)
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "wp-rt-public-tf"
  }
}



resource "aws_route_table_association" "wp-public-tf" {
  count          = length(aws_subnet.wp-public-tf)
  subnet_id      = aws_subnet.wp-public-tf[count.index].id
  route_table_id = aws_route_table.wp-rt-public-tf[count.index].id
}


resource "aws_eip" "eip_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.default]
}


resource "aws_nat_gateway" "wp-private-tf-nat" {
  subnet_id     = aws_subnet.wp-public-tf[0].id
  allocation_id = aws_eip.eip_gateway.id

  tags = {
    Name = "wp-private-tf-nat"
  }

  depends_on = [aws_internet_gateway.default]


}


resource "aws_route_table" "wp-rt-private-tf" {
  count  = length(aws_subnet.wp-private-tf)
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.wp-private-tf-nat.id
  }

  tags = {
    Name = "wp-rt-private-tf"
  }
}

resource "aws_route_table_association" "wp-rt-private-tf" {
  count          = length(aws_subnet.wp-private-tf)
  subnet_id      = aws_subnet.wp-private-tf[count.index].id
  route_table_id = aws_route_table.wp-rt-private-tf[count.index].id
}

