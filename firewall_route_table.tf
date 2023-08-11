resource "aws_default_route_table" "firewall_route_table" {
  default_route_table_id = aws_vpc.firewall_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name = "Firewall Route Table"
  }
}

resource "aws_route_table" "firewall_tgw_a" {
  vpc_id = aws_vpc.firewall_vpc.id
  tags = {
    Name = "Firewall tgw A"
  }
}

resource "aws_route_table" "firewall_tgw_b" {
  vpc_id = aws_vpc.firewall_vpc.id
  tags = {
    Name = "Firewall tgw B"
  }
}

resource "aws_route_table_association" "firewall_tgw_a_ass" {
  subnet_id      = aws_subnet.firewall_tgw_a.id
  route_table_id = aws_route_table.firewall_tgw_a.id
}

resource "aws_route_table_association" "firewall_tgw_b_ass" {
  subnet_id      = aws_subnet.firewall_tgw_b.id
  route_table_id = aws_route_table.firewall_tgw_b.id
}
