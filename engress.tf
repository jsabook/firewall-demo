resource "aws_vpc" "engress" {
  cidr_block = "192.168.0.0/24"
  tags = {
    Name = "Engress VPC"
  }
}
resource "aws_subnet" "public_A" {
  availability_zone = var.zone_A
  vpc_id     = aws_vpc.engress.id
  cidr_block = "192.168.0.0/26"

  tags = {
    Name = "Public subnet Zone A"
  }
}

resource "aws_subnet" "public_B" {
  availability_zone = var.zone_B
  vpc_id     = aws_vpc.engress.id
  cidr_block = "192.168.0.64/26"

  tags = {
    Name = "Public subnet Zone B"
  }
}

resource "aws_subnet" "tgw_engress_A" {
  availability_zone = var.zone_A
  vpc_id     = aws_vpc.engress.id
  cidr_block = "192.168.0.128/26"

  tags = {
    Name = "engress TGW subnet Zone A"
  }
}
resource "aws_subnet" "tgw_engress_B" {
  availability_zone = var.zone_B
  vpc_id     = aws_vpc.engress.id
  cidr_block = "192.168.0.192/26"

  tags = {
    Name = "engress TGW subnet Zone B"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.engress.id

  tags = {
    Name = "engress_igw"
  }
}

resource "aws_eip" "nat_A_ip" {
  vpc      = true
  tags = {
    Name = "nat_A_id"
  }
}
resource "aws_eip" "nat_B_ip" {
  vpc      = true
  tags = {
    Name = "nat_B_id"
  }
}

resource "aws_nat_gateway" "nat_A_engress" {
  allocation_id = aws_eip.nat_A_ip.id
  subnet_id     = aws_subnet.public_A.id
  tags = {
    Name = "Nat engress Zone A"
  }
}
resource "aws_nat_gateway" "nat_B_engress" {
  allocation_id = aws_eip.nat_B_ip.id
  subnet_id     = aws_subnet.public_A.id
 
  tags = {
    Name = "Nat engress Zone B"
  }
}

resource "aws_route_table" "engress_tgw_A" {
  vpc_id = aws_vpc.engress.id
  route {
    cidr_block = "10.0.0.0/8" 
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  } 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_A_engress.id
  } 
  tags = {
    Name = "engress tgw A"
  }
}
resource "aws_route_table_association" "tgw_engress_A_ass" {
  subnet_id      = aws_subnet.tgw_engress_A.id
  route_table_id = aws_route_table.engress_tgw_A.id
}
resource "aws_route_table" "engress_tgw_B" {
  route {
    cidr_block = "10.0.0.0/8" 
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  } 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_B_engress.id
  } 
  vpc_id = aws_vpc.engress.id
  tags = {
    Name = "engress tgw B"
  }
}
resource "aws_route_table_association" "tgw_engress_B_ass" {
  subnet_id      = aws_subnet.tgw_engress_B.id
  route_table_id = aws_route_table.engress_tgw_B.id
}
resource "aws_route_table" "engress_public" {
  vpc_id = aws_vpc.engress.id
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  } 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  } 
  tags = {
    Name = "engress public"
  }
}
resource "aws_route_table_association" "public_A_ass" {
  subnet_id      = aws_subnet.public_A.id
  route_table_id = aws_route_table.engress_public.id
}
resource "aws_route_table_association" "public_B_ass" {
  subnet_id      = aws_subnet.public_B.id
  route_table_id = aws_route_table.engress_public.id
}