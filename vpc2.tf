resource "aws_vpc" "vpc2" {
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "VPC2"
  }
}
resource "aws_subnet" "workload_2_A" {
  availability_zone = var.zone_A
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.0.2.0/26"

  tags = {
    Name = "VPC2 Workload subnet Zone A"
  }
}
resource "aws_subnet" "tgw_2_A" {
  availability_zone = var.zone_A
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.0.2.128/26"

  tags = {
    Name = "VPC2 TGW subnet Zone A"
  }
}
resource "aws_subnet" "workload_2_B" {
  availability_zone = var.zone_B
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.0.2.64/26"

  tags = {
    Name = "VPC2 Workload subnet Zone B"
  }
}
resource "aws_subnet" "tgw_2_B" {
  availability_zone = var.zone_B
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.0.2.192/26"

  tags = {
    Name = "VPC2 TGW subnet Zone B"
  }
}

resource "aws_default_route_table" "vpc2_default_route_table" {
  default_route_table_id = aws_vpc.vpc2.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "vpc2 route table"
  }
}