locals {
  # Map: key (availability zone ID) => value (firewall endpoint ID)
  networkfirewall_endpoints = {
    for i in aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states :
    i.availability_zone => i.attachment[0].endpoint_id
  }
  routing_configuration = {
    "${var.zone_A}" = aws_route_table.firewall_tgw_a.id,
    "${var.zone_B}" = aws_route_table.firewall_tgw_b.id
  }
  availability_zones =  [ var.zone_A,var.zone_B] 
}

resource "aws_networkfirewall_firewall" "firewall" {
  name                = "firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.firewall_policy.arn
  vpc_id              = aws_vpc.firewall_vpc.id
  subnet_mapping {
      subnet_id = aws_subnet.firewall_private_a.id
  }
  subnet_mapping {
      subnet_id = aws_subnet.firewall_private_b.id
  }
}
resource "aws_networkfirewall_firewall_policy" "firewall_policy" {
  name = "Firewall-Policy"
  firewall_policy {
    stateless_default_actions          = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:drop"]
  }
  tags = {
    Name = "Firewall Policy"
  }
}
resource "aws_route" "tgw_to_firewall_endpoint" {
  count = length(local.availability_zones)

  route_table_id         = local.routing_configuration[local.availability_zones[count.index]]
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = local.networkfirewall_endpoints[local.availability_zones[count.index]]
}