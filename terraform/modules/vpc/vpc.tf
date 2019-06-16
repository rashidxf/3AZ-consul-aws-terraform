resource "aws_vpc" "env" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = {
    Name = "consul-vpc"
    Owner = "${var.owner}"
  }
}

//Create three public subnets for NAT GWs and Bastion VMs

resource "aws_subnet" "public" {
  count             = "${length(var.public_subnets)}"
  vpc_id            = "${aws_vpc.env.id}"
  cidr_block        = "${element(var.public_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "public-subnet-${count.index}"
    Owner = "${var.owner}"
  }
  map_public_ip_on_launch = true
}

// Create three private subnets for consul cluster present in three AZs

resource "aws_subnet" "private" {
  count             = "${length(var.private_subnets)}"
  vpc_id            = "${aws_vpc.env.id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "private-subnet-${count.index}"
    Owner = "${var.owner}"
  }
  map_public_ip_on_launch = true
}


// Create an Internet Gateway for the VPC.

resource "aws_internet_gateway" "consul" {
  vpc_id = "${aws_vpc.env.id}"  // One VPC spans all AZ and networks, We will create  one IG. 
                                //Networks in IG route table are public, others are private

  tags = {
    Name = "Consul-IG"
    owner = "${var.owner}"
  }
}

// Create Three NAT GWs for each Avalblity Zone

resource "aws_nat_gateway" "private" {
  count         = "${length(var.private_subnets)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"  //Elastic IP of NAT Gateway to which internal IPs will be NATed 
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}" //Subnet ID of subnet in which to place the NAT GW 

  depends_on = ["aws_internet_gateway.consul"]
  
  tags = {
    Name = "consul-NATGW-${element(aws_subnet.public.*.id, count.index)}"
    Owner = "${var.owner}"
  }
}

// Create Elastic IPs

resource "aws_eip" "nat" {  
  count = "${length(var.private_subnets)}" 
  vpc   = true
  tags = {
    Name = "Elastic-IP"
    Owner = "${var.owner}"
  }

}

// Create Route Tables

resource "aws_route_table" "public" {
  count  = "${length(var.public_subnets)}"
  vpc_id = "${aws_vpc.env.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.consul.id}" //Same IG is assigned three route tables, IG identifier for the tables. 
  }
  tags = {
  Name = "Public-route-table-${aws_internet_gateway.consul.id}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"

}

resource "aws_route_table" "private" {
  count  = "${length(var.private_subnets)}"
  vpc_id = "${aws_vpc.env.id}"

  route {                                          //Route table for NAT GWs and private subnets
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.private.*.id, count.index)}"
  }
  tags = {
    Name = "Private-route-table-${element(aws_nat_gateway.private.*.id, count.index)}"
  }

}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
