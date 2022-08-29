#Availabilty zone through data source
data "aws_availability_zones" "availabilityZone" {
  
}
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc["vpcCidr"]
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.name}-VPC"
  }
}
resource "aws_subnet" "publicSubnet" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.vpc["publicSubnet"])
  cidr_block = element(var.vpc["publicSubnet"], count.index)
  availability_zone = element(data.aws_availability_zones.availabilityZone.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.name}-PubSubnet-${count.index + 1}"
    Tier = "Public"
  }
}

resource "aws_subnet" "privateSubnet" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.vpc["privateSubnet"])
  cidr_block = element(var.vpc["privateSubnet"], count.index)
  availability_zone = element(data.aws_availability_zones.availabilityZone.names, count.index)
  tags = {
    "Name" = "${var.name}-PrivSubnet-${count.index + 1}"
    Tier = "Private"
  }
}

#Internet Gateway and Public Route table & Subnet Assoications.
resource "aws_internet_gateway" "main-IGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.name}-IGW"
  }
}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-IGW.id
  }
  tags = {
    "Name" = "${var.name}-PublicRT"
  }
}
resource "aws_route_table_association" "publicRTAssoication" {
  count = length(var.vpc["publicSubnet"])
  subnet_id = element(aws_subnet.publicSubnet.*.id , count.index)
  route_table_id = aws_route_table.publicRouteTable.id
}

#Nat Gateway, private Route table & Subnet Assoications. 

#Elastic IP
resource "aws_eip" "eip" {
  count = length(var.vpc["privateSubnet"]) > 0 ? 1 : 0
  vpc = true
}

resource "aws_nat_gateway" "natgateway" {
  count = length(var.vpc["privateSubnet"]) > 0 ? 1 : 0
  allocation_id = aws_eip.eip[0].id
  subnet_id = aws_subnet.publicSubnet[0].id
  depends_on = [
    aws_internet_gateway.main-IGW
  ]

  tags = {
    "Name" = "${var.name}-NAT"
  }
}
resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgateway[0].id
  }
  tags = {
    "Name" = "${var.name}-PrivateRT"
  }
}
# resource "aws_route" "NATGatewayRouting" {
#   route_table_id = aws_route_table.PrivateRouteTable.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.natgateway[0].id
# }
resource "aws_route_table_association" "privateRTAssoication" {
  count = length(var.vpc["privateSubnet"]) 
  subnet_id = element(aws_subnet.privateSubnet.*.id , count.index)
  route_table_id = aws_route_table.PrivateRouteTable.id
  depends_on = [
    aws_subnet.privateSubnet
  ]
}