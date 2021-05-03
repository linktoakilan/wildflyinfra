# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.vpccidr
  enable_dns_hostnames = var.enable_dns_hostname
  tags = {
    "Name" = var.vpc_name
  }
}
# Create Public Subnet

resource "aws_subnet" "publicsubnets" {
    count = length(var.pubsub_name)

  vpc_id     = aws_vpc.example.id
  cidr_block = element(var.pubsub_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = element(var.pubsub_name,count.index)
  }
}
# Create Private Subnet

resource "aws_subnet" "privatesubnets" {
    count = length(var.prisub_name)

  vpc_id     = aws_vpc.example.id
  cidr_block = element(var.prisub_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = element(var.prisub_name,count.index)
  }
}
# Create Internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = var.igwname
  }
}

# Create NAT Elastic IP

resource "aws_eip" "natip" {  
  vpc      = true
}

# Create NAT gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natip.id
  subnet_id     = element(aws_subnet.publicsubnets.*.id, 0)
}

# Create public Route Table
resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.example.id
    tags = {
    Name = "publicroutetable"
  }
}
# Create private Route Table
resource "aws_route_table" "privatedroutetable" {
  vpc_id = aws_vpc.example.id
   tags = {
    Name = "privatedroutetable"
  }
}

# Associate Public subnets with Public Route table

resource "aws_route_table_association" "public" {
  count = length(var.pubsub_name)

  subnet_id = element(aws_subnet.publicsubnets.*.id, count.index)
  route_table_id = element(aws_route_table.publicroutetable.*.id,0)
}

# Associate Private subnets with Private Route table

resource "aws_route_table_association" "private" {
  count = length(var.prisub_name)

  subnet_id = element(aws_subnet.privatesubnets.*.id, count.index)
  route_table_id = element(aws_route_table.privatedroutetable.*.id,0)
}

# Public Internet RouetOut

resource "aws_route" "publicigwout" {
  route_table_id            = aws_route_table.publicroutetable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  depends_on = [aws_internet_gateway.igw]
}

# Private Internet RouetOut

resource "aws_route" "privatenatgwout" {
  route_table_id            = aws_route_table.privatedroutetable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.natgw.id
  depends_on = [aws_nat_gateway.natgw]
}

resource "aws_security_group" "public_sg" {
  vpc_id      = aws_vpc.example.id
  tags = {
    Name = "public_sg"
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id      = aws_vpc.example.id
  tags = {
    Name = "private_sg"
  }
}

resource "aws_security_group_rule" "Allowhttp80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "Allowssh22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "AllowAllSelf" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  self       = true
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "AllowAllEgress" {
  type              = "egress" 
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}


resource "aws_security_group_rule" "privateAllowAllEgress" {
  type              = "egress" 
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_sg.id
}

resource "aws_security_group_rule" "AllowAllSelfprivate" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  self       = true
  security_group_id = aws_security_group.private_sg.id
}

resource "aws_security_group_rule" "AllowAllfrompublictoPrivate" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id       = aws_security_group.public_sg.id
  security_group_id = aws_security_group.public_sg.id
}