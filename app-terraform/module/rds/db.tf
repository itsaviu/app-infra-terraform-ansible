resource "aws_db_instance" "psql-db" {
  allocated_storage        = 20
  backup_retention_period  = 7   # in days
  db_subnet_group_name     = aws_db_subnet_group.subnet_group.id
  engine                   = "postgres"
  engine_version           = "9.5.4"
  identifier               = "mydb1"
  instance_class           = "db.t2.micro"
  multi_az                 = false
  name                     = "webappdb"
  password                 = "postgresql"
  port                     = 5432
  publicly_accessible      = false
  storage_encrypted        = false
  storage_type             = "gp2"
  username                 = "postgres"
  vpc_security_group_ids   = [aws_security_group.db_sg.id]
  skip_final_snapshot      = true
  tags = {
    Name = "APP_DB_INSTANCE"
    Owner = "Avi"
  }
}


resource "aws_db_subnet_group" "subnet_group" {
  subnet_ids = var.SUBNET_IDS
}


resource "aws_security_group" "db_sg" {
  name = "WEBAPP DB INSTANCE"
  description = "RDS postgres servers (terraform-managed)"
  vpc_id = var.VPC_ID

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = var.ACCESSIBLE_INSTANCE_SG
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "DB SG"
    Owner    = "Avi"
  }
}
