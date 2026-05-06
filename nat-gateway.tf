#Elastic IP for the NAT Gateway in AZ-B
resource "aws_eip" "nat_eip_az_b" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip-az-b"
  }
}

# NAT Gateway in Public Subnet 2 (AZ-B)
resource "aws_nat_gateway" "nat_az_b" {
  allocation_id = aws_eip.nat_eip_az_b.id
  subnet_id = data.aws_subnet.public_subnet_2.id
  tags = {
    Name = "${var.project_name}-nat-gateway-az-b"
  }
}

# Add a route in Private Subnet 2's route table to the NAT Gateway
resource "aws_route" "private_subnet_2_nat_route" {
  route_table_id = data.aws_route_table.private_subnet_2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_az_b.id
}