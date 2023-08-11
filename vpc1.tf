
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "VPC1"
  }
}
resource "aws_subnet" "workload_1_A" {
  availability_zone = var.zone_A
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/26"

  tags = {
    Name = "VPC1 Workload subnet Zone A"
  }
}
resource "aws_subnet" "workload_1_B" {
  availability_zone = var.zone_B
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.64/26"

  tags = {
    Name = "VPC1 Workload subnet Zone B"
  }
}
resource "aws_subnet" "tgw_1_A" {
  availability_zone = var.zone_A
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.128/26"
  tags = {
    Name = "VPC1 TGW subnet Zone A"
  }
}

resource "aws_subnet" "tgw_1_B" {
  availability_zone = var.zone_B
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.192/26"

  tags = {
    Name = "VPC1 TGW subnet Zone B"
  }
}

resource "aws_default_route_table" "vpc1_default_route_table" {
  default_route_table_id = aws_vpc.vpc1.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "vpc1 route table"
  }
}