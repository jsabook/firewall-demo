
resource "aws_vpc" "firewall_vpc" {
  cidr_block = "192.168.1.0/26"
  tags = {
    Name = "Firewall Vpc"
  }
}
resource "aws_subnet" "firewall_tgw_a" {
  availability_zone = var.zone_A
  vpc_id     = aws_vpc.firewall_vpc.id
  cidr_block = "192.168.1.0/28"

  tags = {
    Name = "Subnet Tgw A"
  }
}
resource "aws_subnet" "firewall_tgw_b" {
  availability_zone = var.zone_B
  vpc_id     = aws_vpc.firewall_vpc.id
  cidr_block = "192.168.1.16/28"

  tags = {
    Name = "Firewall Tgw B"
  }
}
resource "aws_subnet" "firewall_private_a" {
  availability_zone = var.zone_A
  vpc_id     = aws_vpc.firewall_vpc.id
  cidr_block = "192.168.1.32/28"
  tags = {
    Name = "Firewall Private A"
  }
}

resource "aws_subnet" "firewall_private_b" {
  availability_zone = var.zone_B
  vpc_id     = aws_vpc.firewall_vpc.id
  cidr_block = "192.168.1.48/28"

  tags = {
    Name = "Firewall Private B"
  }
}