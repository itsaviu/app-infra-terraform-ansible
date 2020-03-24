resource "aws_subnet" "proxy_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id = var.VPC_ID
  availability_zone = "us-east-1a"
  tags = {
    Name = "Webapp-proxy-subnet"
    Owner = "Avi"
  }
}

resource "aws_subnet" "webapp_subnet" {
  cidr_block = "10.0.3.0/24"
  vpc_id = var.VPC_ID
  availability_zone = "us-east-1b"
  tags = {
    Name = "Webapp-instance-subnet"
    Owner = "Avi"
  }
}


resource "aws_subnet" "proxy_2_subnet" {
  cidr_block = "10.0.4.0/24"
  vpc_id = var.VPC_ID
  availability_zone = "us-east-1c"
  tags = {
    Name = "Webapp-proxy-2-subnet"
    Owner = "Avi"
  }
}


resource "aws_eip" "elastic_ip" {
  vpc = true
}

resource "aws_nat_gateway" "private-nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id = var.PUBLIC_SUBNET_ID
  tags = {
    Name = "private-instance-nat"
    Owner = "Avi"
  }
}


resource "aws_route_table" "private-nat-route" {
  vpc_id = var.VPC_ID
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private-nat.id
  }
  tags = {
    Name = "private-instance-nat-route"
    Owner = "Avi"
  }
}
