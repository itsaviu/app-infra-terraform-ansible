resource "aws_instance" "instance" {
  ami = var.INSTANCE_AMI
  instance_type = var.INSTANCE_TYPE
  subnet_id = var.SUBNET_ID
  security_groups = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true
  key_name = var.KEY_PAIR_ID

  connection {
    host = self.private_ip
    private_key = file(var.SSH_SECRET_KEY)
    user        = "ubuntu"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get update && sudo apt-get -qq install python -y"]
  }

  provisioner "local-exec" {
    command = <<EOT
              sleep 20;
              ansible-playbook -i '${self.private_ip},' --private-key ${var.SSH_SECRET_KEY} -u ubuntu  ~/app-ansible/proxy.yml --extra-vars 'hostname=${var.PROXY_PASS_HOST}' -vvv
          EOT
  }

  tags = {
    Name = var.RESOURCE_NAME
    purpose= "POC - Learning"
    businessunit= "DevOps"
    Owner = "Avi"
    will_be_removed = true
  }
}

resource "aws_security_group" "instance_sg" {
  name = var.SG_NAME

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
    security_groups = var.REQUESTOR_INSTANCE_SG
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = var.VPC_ID

  tags = {
    Name     = var.SG_NAME
    Owner    = "Avi"
  }
}


resource "aws_route_table_association" "private-route-asso" {
  route_table_id = var.ROUTE_TABLE_ID
  subnet_id = var.SUBNET_ID
}
