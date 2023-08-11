resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transact firewall demo"
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "disable"
  tags ={
    Name = "AWS Transit Gateway"
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc1_attach" {
  subnet_ids         = [aws_subnet.tgw_1_A.id,aws_subnet.tgw_1_B.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc1.id
  tags = {
    Name = "tgw vpc1 attach"
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc2_attach" {
  subnet_ids         = [aws_subnet.tgw_2_A.id,aws_subnet.tgw_2_B.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc2.id
  tags = {
    Name = "tgw vpc2 attach"
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_engress_attach" {
  subnet_ids         = [aws_subnet.tgw_engress_A.id,aws_subnet.tgw_engress_B.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.engress.id
  tags = {
    Name = "tgw engress attach"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_firewall_attach" {
  subnet_ids         = [aws_subnet.firewall_tgw_a.id,aws_subnet.firewall_tgw_a.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.firewall_vpc.id
  tags = {
    Name = "firewall attach"
  }
}

resource "aws_ec2_transit_gateway_route_table" "firewall_tgw" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "Firewall TGW Route Table"
  }
}
resource "aws_ec2_transit_gateway_route_table" "inspection_tgw" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "Inspection TGW Route Table"
  }
}
resource "aws_ec2_transit_gateway_route" "inspection_tgw_route_default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_firewall_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection_tgw.id
}
resource "aws_ec2_transit_gateway_route" "firewall_tgw_route_to_vpc1" {
  destination_cidr_block         = "10.0.1.0/24"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc1_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_tgw.id
}
resource "aws_ec2_transit_gateway_route" "firewall_tgw_route_to_vpc2" {
  destination_cidr_block         = "10.0.2.0/24"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc2_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_tgw.id
}
resource "aws_ec2_transit_gateway_route" "firewall_tgw_route_to_engress" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_engress_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_tgw.id
}

resource "aws_ec2_transit_gateway_route_table_association" "firewall_rt_ass_firewall_tgw" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_firewall_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_tgw.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc1_tgw_ass_inspect_rt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc1_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection_tgw.id
}
resource "aws_ec2_transit_gateway_route_table_association" "vpc2_tgw_ass_inspect_rt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc2_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection_tgw.id
}
resource "aws_ec2_transit_gateway_route_table_association" "engress_tgw_ass_inspect_rt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_engress_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection_tgw.id
}