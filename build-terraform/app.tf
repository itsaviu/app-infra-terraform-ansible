locals {
  SECRET_PUB_FILE="/Users/avinash/.ssh/secret_key.pub"
  SSH_SECRET="/Users/avinash/.ssh/secret_key"
}


resource "aws_key_pair" "keypair" {
  key_name   =   "webapp_key"
  public_key =   file(local.SECRET_PUB_FILE)
  tags = {
    Name     =   "webapp_key"
    Owner    =   "Avi"
    purpose= "POC - Learning"
    businessunit= "DevOps"
  }
}

resource "aws_vpc" "build-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "BUILD VPC"
    Owner = "Avi"
    purpose= "POC - Learning"
    businessunit= "DevOps"
  }
}

resource "aws_subnet" "build-subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.build-vpc.id
  tags = {
    Name = "BUILD SUBNET"
    Owner = "Avi"
    purpose= "POC - Learning"
    businessunit= "DevOps"
  }
}


resource "aws_internet_gateway" "build-ig" {
  vpc_id = aws_vpc.build-vpc.id
  tags = {
    Name = "BUILD IG"
    Owner = "Avi"
    purpose= "POC - Learning"
    businessunit= "DevOps"
  }
}


resource "aws_route_table" "build-route" {
  vpc_id = aws_vpc.build-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.build-ig.id
  }
  tags = {
    Name = "BUILD ROUTE"
    Owner = "Avi"
    purpose= "POC - Learning"
    businessunit= "DevOps"
  }
}

resource "aws_route_table_association" "build-association" {
  route_table_id = aws_route_table.build-route.id
  subnet_id = aws_subnet.build-subnet.id
}

resource "aws_instance" "build_instance" {
  ami = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name = aws_key_pair.keypair.id
  security_groups = [aws_security_group.sg.id]
  associate_public_ip_address = true
  subnet_id = aws_subnet.build-subnet.id
  tags = {
    Name = "BUILD INSTANCE"
    Owner = "Avi"
    purpose= "POC - Learning"
    businessunit= "DevOps"
  }

  connection {
    host = self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = file(local.SSH_SECRET)
  }

  provisioner "local-exec" {
    command = <<EOT
        export ANSIBLE_HOST_KEY_CHECKING=False
        ansible-playbook -i '${self.public_ip},' --private-key ${local.SSH_SECRET} -u ubuntu  ../build-ansible/playbook.yml --extra-vars '' -vvv
      EOT
  }

}




resource "aws_security_group" "sg" {

  name = "Build-Sg"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.build-vpc.id

  tags = {
    Name = "BUILD SUBNET"
    Owner = "Avi"
    purpose= "POC - Learning"
    businessunit= "DevOps"
  }

}

