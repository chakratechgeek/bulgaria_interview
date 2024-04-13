resource "aws_vpc" "inter_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "interview_vpc"
  }
}

resource "aws_subnet" "inter_app_subnet" {
  vpc_id            = aws_vpc.inter_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "app_subnet"
  }
}

resource "aws_subnet" "inter_db_subnet_prim" {
  vpc_id            = aws_vpc.inter_vpc.id
  cidr_block        = var.private_subnet_cidr_prim
  availability_zone = var.private_availability_zone_prim

  tags = {
    Name = "db_subnet"
  }
}

resource "aws_subnet" "inter_db_subnet_stby" {
  vpc_id            = aws_vpc.inter_vpc.id
  cidr_block        = var.private_subnet_cidr_stby
  availability_zone = var.private_availability_zone_stby

  tags = {
    Name = "db_subnet"
  }
}

resource "aws_internet_gateway" "inter_igw" {
  vpc_id = aws_vpc.inter_vpc.id

  tags = {
    Name = "inter_igw"
  }
}

resource "aws_route_table_association" "inter_rt_associate_public" {
  subnet_id      = aws_subnet.inter_app_subnet.id
  route_table_id = aws_route_table.inter_rt_public.id
}

resource "aws_eip" "inter_nat_eip" {
  vpc = true

  tags = {
    Name = "example-eip-nat"
  }
}

resource "aws_nat_gateway" "inter_nat_gw" {
  allocation_id = aws_eip.inter_nat_eip.id
  subnet_id     = aws_subnet.inter_app_subnet.id

  tags = {
    Name = "inter_nat_gw"
  }
}


resource "aws_route_table" "inter_rt_public" {
  vpc_id = aws_vpc.inter_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inter_igw.id
  }

  tags = {
    Name = "inter_rt_public"
  }
}


resource "aws_route_table" "inter_rt_private" {
  vpc_id = aws_vpc.inter_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.inter_nat_gw.id
  }

  tags = {
    Name = "inter_rt_private"
  }
}

resource "aws_route_table_association" "inter_rt_associate_private_prim" {
  subnet_id      = aws_subnet.inter_db_subnet_prim.id
  route_table_id = aws_route_table.inter_rt_private.id
}

resource "aws_route_table_association" "inter_rt_associate_private_stby" {
  subnet_id      = aws_subnet.inter_db_subnet_stby.id
  route_table_id = aws_route_table.inter_rt_private.id
}
