resource "aws_elb" "service_elb" {
  name = "app"
  subnets = var.INSTANCE_SUBNETS
  security_groups = [aws_security_group.elb_sg.id]
  listener {
    instance_port = 80
    instance_protocol= "http"
    lb_port = 80
    lb_protocol = "http"
  }
  instances = var.INSTANCES

  tags = {
    Name = var.RESOURCE_NAME
    Owner = "Avi"
  }
}


resource "aws_security_group" "elb_sg" {
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


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = var.VPC_ID

  tags = {
    Name = "BUILD SUBNET"
    Owner = "Avi"
  }
}
