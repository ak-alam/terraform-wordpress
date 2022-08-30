#Availabilty zone through data source
data "aws_availability_zones" "availabilityZone" {
  
}
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc["vpc_cidr"]
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.prefix}-VPC"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.vpc["public_subnet"])
  cidr_block = element(var.vpc["public_subnet"], count.index)
  availability_zone = element(data.aws_availability_zones.availabilityZone.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.prefix}-public_subnet-${count.index + 1}"
    Tier = "Public"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.vpc["private_subnet"])
  cidr_block = element(var.vpc["private_subnet"], count.index)
  availability_zone = element(data.aws_availability_zones.availabilityZone.names, count.index)
  tags = {
    "Name" = "${var.prefix}-private-subnet-${count.index + 1}"
    Tier = "Private"
  }
}

#Internet Gateway and Public Route table & Subnet Assoications.
resource "aws_internet_gateway" "main-IGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.prefix}-IGW"
  }
}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-IGW.id
  }
  tags = {
    "Name" = "${var.prefix}-PublicRT"
  }
}
resource "aws_route_table_association" "publicRTAssoication" {
  count = length(var.vpc["public_subnet"])
  subnet_id = element(aws_subnet.public_subnet.*.id , count.index)
  route_table_id = aws_route_table.publicRouteTable.id
}

#Nat Gateway, private Route table & Subnet Assoications. 

#Elastic IP
resource "aws_eip" "eip" {
  count = length(var.vpc["private_subnet"]) > 0 ? 1 : 0
  vpc = true
}

resource "aws_nat_gateway" "natgateway" {
  count = length(var.vpc["private_subnet"]) > 0 ? 1 : 0
  allocation_id = aws_eip.eip[0].id
  subnet_id = aws_subnet.public_subnet[0].id
  depends_on = [
    aws_internet_gateway.main-IGW
  ]

  tags = {
    "Name" = "${var.prefix}-NAT"
  }
}
resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgateway[0].id
  }
  tags = {
    "Name" = "${var.prefix}-PrivateRT"
  }
}
# resource "aws_route" "NATGatewayRouting" {
#   route_table_id = aws_route_table.PrivateRouteTable.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.natgateway[0].id
# }
resource "aws_route_table_association" "privateRTAssoication" {
  count = length(var.vpc["private_subnet"]) 
  subnet_id = element(aws_subnet.private_subnet.*.id , count.index)
  route_table_id = aws_route_table.PrivateRouteTable.id
  depends_on = [
    aws_subnet.private_subnet
  ]
}